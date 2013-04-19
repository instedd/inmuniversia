class Channel < ActiveRecord::Base
  belongs_to :subscriber
  
  attr_accessible :notifications_enabled, :address, :verification_code

  validates :address, presence: true

  scope :sms,   where(type: 'Channel::Sms')
  scope :email, where(type: 'Channel::Email')

  def send_reminders(reminders, subscriber)
    do_send_reminders(reminders, subscriber)
    reminders.update_all(status: 'sent', sent_at: DateTime.now)
  end

  protected

  def do_send_reminders(reminders, subscriber)
    subclass_responsibility
  end

end
