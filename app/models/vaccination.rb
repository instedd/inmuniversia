class Vaccination < ActiveRecord::Base
  
  extend Enumerize

  belongs_to :vaccine, :class_name => '::Vaccine'
  belongs_to :dose
  belongs_to :child

  has_many :reminders

  enumerize :status, in: %w(planned taken past), predicates: true, default: 'planned'

  attr_accessible :child_id, :dose_id, :vaccine_id, :taken_at, :planned_date, :status
  attr_accessible :child, :vaccine, :dose

  after_create  :create_reminders!

  before_save do |vaccination|
    vaccination.vaccine ||= vaccination.dose.vaccine if vaccination.dose
  end

  scope :planned, where(status: :planned)
  scope :taken,   where(status: :taken)
  scope :past,    where(status: :past)

  def date
    taken_at || planned_date
  end

  def next_reminder
    today = Date.today
    reminders.pending.first
  end

  def next_reminder_date
    next_reminder.try(:send_at)
  end

  protected

  # TODO: Define how reminders are to be managed and created, they should depend on the dose
  def create_reminders!
    reminders << ReminderUpcomingDose.new
    reminders << ReminderCurrentDose.new
    reminders << ReminderAfterDose.new
  end

end
