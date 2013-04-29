class CalendarPresenter::Timespan
  include Comparable
  extend Concerns::Timespanize

  timespanize :age
  
  attr_accessor :age_unit
  attr_accessor :age_value
  attr_accessor :dob

  def self.from(vaccination)
    self.new(vaccination.planned_age_value, vaccination.planned_age_unit, vaccination.child.date_of_birth)
  end

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