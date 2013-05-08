class CalendarPresenter

  attr_accessor :child
  attr_accessor :vaccines
  attr_accessor :timespans

  def initialize(child)
    @child = child

    @subscriptions =     load_subscriptions
    @vaccines =          load_vaccines
    @timespans =         load_timespans
    @vaccination_slots = load_vaccination_slots
  end

  def vaccinations_for(vaccine)
    @vaccination_slots[vaccine]
  end

  def vaccinations_with_timespans_for(vaccine)
    vaccinations_for(vaccine).zip(timespans)
  end

  def active_vaccines
    @vaccines.select(&:status_active?)
  end

  def vaccines
    @vaccines
  end

  protected

  def load_subscriptions
    child.subscriptions.to_a
  end

  def load_timespans
    # TODO: Detect overlaps in timestamps
    # HACK: Array#uniq does not use eql? or == for equality, therefore the uniqueness check is made manually
    timespans = []
    @subscriptions.select(&:status_active?).map(&:vaccinations).flatten.each do |vaccination|
      timespan = Timespan.new(vaccination.planned_age_value, vaccination.planned_age_unit, child.date_of_birth)
      timespans << timespan unless timespans.include?(timespan)
    end
    timespans << CurrentTimespan.new unless timespans.any?(&:current?)
    return timespans.sort
  end

  def load_vaccination_slots
    vaccination_slots = {}
    active_vaccines.each do |vaccine|
      vaccination_slots[vaccine] = load_vaccination_slots_for(vaccine)
    end

    return vaccination_slots
  end

  def load_vaccination_slots_for(vaccine)
    slots = [nil] * timespans.length
    vaccine.vaccinations.each do |vaccination|
      index = timespans.index {|t| vaccination.planned_age == t.age}
      slots[index] = vaccination
    end

    return slots
  end

  def load_vaccines
    @subscriptions.map do |subscription|
      VaccinePresenter.new(subscription.vaccine, subscription: subscription)
    end
  end

end