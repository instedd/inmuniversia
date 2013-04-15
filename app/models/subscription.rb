class Subscription < ActiveRecord::Base
  
  extend Enumerize

  belongs_to :vaccine, class_name: '::Vaccine'
  belongs_to :child

  attr_accessible :status, :vaccine, :child

  enumerize :status, in: %w(active disabled), predicates: {prefix: true}, default: :active

  validates :vaccine_id, presence: true, uniqueness: {scope: :child_id}

  after_create :generate_notifications!

  def subscriber
    child.parent
  end

  def generate_notifications!
    child.pending_doses_for(vaccine).each do |dose|
      date = dose.date_for(child)
      register_dose_notification(dose, date) if date
    end
  end

  protected

  def register_dose_notification(dose, date)
    Notification.register_dose(subscription: self, dose: dose, date: date)
  end

end
