class Subscription < ActiveRecord::Base
  
  extend Enumerize

  belongs_to :vaccine, class_name: '::Vaccine'
  belongs_to :child

  attr_accessible :status, :vaccine, :child

  enumerize :status, in: %w(active disabled), predicates: {prefix: true}, default: :active

  validates :vaccine_id, presence: true, uniqueness: {scope: :child_id}

  def subscriber
    child.parent
  end

  def next_vaccination
    vaccinations.planned.sort_by(&:planned_date).first
  end

  def next_reminder_date
    vaccinations.planned.map(&:next_reminder_date).compact.min
  end

  def vaccinations
    child.vaccinations.where(vaccine_id: vaccine_id)
  end

end
