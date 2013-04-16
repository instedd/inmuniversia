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

  def next_planned_vaccination
    vaccinations.planned.to_a.min_by(&:planned_date)
  end

  def vaccinations
    child.vaccinations.where(vaccine_id: vaccine_id)
  end

end
