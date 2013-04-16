class Vaccination < ActiveRecord::Base
  
  extend Enumerize

  belongs_to :vaccine, :class_name => '::Vaccine'
  belongs_to :dose
  belongs_to :child

  enumerize :status, in: %w(planned taken past), predicates: true, default: 'planned'

  attr_accessible :child_id, :dose_id, :vaccine_id, :taken_at, :planned_date, :status
  attr_accessible :child, :vaccine, :dose

  before_save do |vaccination|
    vaccination.vaccine ||= vaccination.dose.vaccine if vaccination.dose
  end

  scope :planned, where(status: :planned)
  scope :taken,   where(status: :taken)
  scope :past,    where(status: :past)

  def date
    taken_at || planned_date
  end
  
end
