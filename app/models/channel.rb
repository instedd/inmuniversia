class Channel < ActiveRecord::Base
  belongs_to :subscriber

  attr_accessible :notifications_enabled, :address, :verification_code

  validates :address, presence: true

  scope :sms,   where(type: 'Channel::Sms')
  scope :email, where(type: 'Channel::Email')

  def send_reminders(reminders)
    do_send_reminders(reminders)
    reminders.update_all(status: 'sent', sent_at: DateTime.now)
  end

  def to_partial_path
    "channels/#{self.class.name.split(/::/).last.underscore}"
  end

  protected

  def do_send_reminders(reminders)
    subclass_responsibility
  end

end
