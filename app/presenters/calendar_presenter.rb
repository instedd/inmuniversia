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


  class Timespan
    include Comparable
    extend Concerns::Timespanize

    timespanize :age
    
    attr_accessor :age_unit
    attr_accessor :age_value
    attr_accessor :dob

    def initialize(age_value, age_unit, dob)
      self.age_value = age_value
      self.age_unit = age_unit
      self.dob = dob
    end

    def <=>(other)
      [self.age, self.age_end] <=> [other.age, other.age_end]
    end

    def ==(other)
      self.age == other.age
    end

    def year
      (self.dob + age).year
    end

    def month
      (self.dob + age).month
    end

    def month_name
      Date.new(year, month).strftime("%B")
    end

  end


  class Vaccine
    def initialize(vaccine)
      @model = vaccine
    end

    def id
      @model.id
    end

    def name
      @model.name
    end

    def diseases
      @model.diseases
    end

    def diseases_list
      diseases.map(&:name).join(", ")
    end
  end


  class Vaccination
    def initialize(vaccination)
      @model = vaccination
    end

    def name
      @model.dose.name
    end

    def status
      @model.status
    end
  end


  protected


  def load_vaccines
    ::Vaccine.defaults.map{|v| Vaccine.new(v)}
  end

  def load_timespans
    # TODO: Detect overlaps in timestamps
    # HACK: Array#uniq does not use eql? or == for equality, therefore the uniqueness check is made manually
    timespans = []
    child.vaccinations.each do |vaccination|
      timespan = Timespan.new(vaccination.planned_age_value, vaccination.planned_age_unit, child.date_of_birth)
      timespans << timespan unless timespans.include?(timespan)
    end
    return timespans.sort
  end

  def load_vaccination_slots(vaccine)
    slots = [nil] * timespans.length
    child.vaccinations.select{|v| v.vaccine_id == vaccine.id}.each do |vaccination|
      index = timespans.index {|t| vaccination.planned_age == t.age}
      slots[index] = Vaccination.new(vaccination)
    end

    return slots
  end

  def vaccinations
    @vaccinations
  end

end