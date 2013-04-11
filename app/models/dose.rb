class Dose < ActiveRecord::Base
  
  belongs_to :vaccine, :class_name => '::Vaccine'
  acts_as_list scope: :vaccine, column: :number

  attr_accessible :age_unit, :age_value, :interval_unit, :interval_value, :name, :number

  def date_for(child)
    subclass_responsibility
  end

  def in_date_for?(child)
    date = date_for(child)
    date && date <= Date.today
  end

  def vaccination_for(child)
    child.vaccinations.find{|v| v.dose == self}
  end

  def full_name
    "#{name} de #{vaccine.name}"
  end
end
