class Vaccination < ActiveRecord::Base
  belongs_to :vaccine, :class_name => '::Vaccine'
  belongs_to :dose
  belongs_to :child

  attr_accessible :child_id, :child, :date, :dose_id, :dose, :vaccine_id, :vaccine

  before_save do |vaccination|
    vaccination.vaccine ||= vaccination.dose.vaccine if vaccination.dose
  end
end
