class CalendarPresenter

  attr_accessor :child
  attr_accessor :vaccines
  attr_accessor :timespans

  def initialize(child)
    @child = child
    @vaccines = load_vaccines
    @timespans = load_timespans
    @vaccinations = {}
  end

  def vaccinations_for(vaccine)
    @vaccinations[vaccine] ||= load_vaccination_slots(vaccine)
  end

  def vaccinations_with_timespans_for(vaccine)
    vaccinations_for(vaccine).zip(timespans)
  end

  protected

  def load_vaccines
    VaccinePresenter.present(::Vaccine.defaults)
  end

  def load_timespans
    # TODO: Detect overlaps in timestamps
    # HACK: Array#uniq does not use eql? or == for equality, therefore the uniqueness check is made manually
    timespans = []
    child.vaccinations.each do |vaccination|
      timespan = Timespan.new(vaccination.planned_age_value, vaccination.planned_age_unit, child.date_of_birth)
      timespans << timespan unless timespans.include?(timespan)
    end
    timespans << CurrentTimespan.new unless timespans.any?(&:current?)
    return timespans.sort
  end

  def load_vaccination_slots(vaccine)
    slots = [nil] * timespans.length
    child.vaccinations.select{|v| v.vaccine_id == vaccine.id}.each do |vaccination|
      index = timespans.index {|t| vaccination.planned_age == t.age}
      slots[index] = VaccinationPresenter.new(vaccination)
    end

    return slots
  end

  def vaccinations
    @vaccinations
  end

end