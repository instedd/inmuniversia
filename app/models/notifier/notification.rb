class Notifier::Notification < Struct.new(:channel_id, :reminders_ids, :subscriber_id)

  def initialize(channel, reminders, subscriber)
    self.reminders_ids = reminders.map(&:id)
    self.subscriber_id = subscriber.id
    self.channel_id = channel.id
  end

  def perform
    channel = Channel.find(self.channel_id)
    subscriber = Subscriber.find(self.subscriber_id)
    reminders = Reminder.where(id: self.reminders_ids)
    
    # TODO: Validate if these subscriber, channel and reminders are still elligible for sending
    return unless channel && subscriber && reminders.any?
    channel.send_reminders(reminders, subscriber)
  end

  def self.enqueue(channel, reminders, subscriber)
    self.new(channel, reminders, subscriber).tap do |notification|
      Delayed::Job.enqueue(notification)
    end
  end

end