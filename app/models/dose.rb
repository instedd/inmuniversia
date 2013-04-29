class Dose < ActiveRecord::Base
  
  belongs_to :vaccine, class_name: '::Vaccine'
  has_many :vaccinations, dependent: :destroy

  acts_as_list scope: :vaccine, column: :number

  attr_accessible :age_unit, :age_value, :interval_unit, :interval_value, :name, :number

  def date_for(child)
    subclass_responsibility
  end

  def span
    subclass_responsibility
  end

  def vaccination_for(child)
    child.vaccinations.find{|v| v.dose == self}
  end

  def full_name
    "#{name} de #{vaccine.name}"
  end

  def previous_dose
    self.higher_item
  end

  def next_dose
    self.lower_item
  end

end
