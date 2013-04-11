class Notification < Delayed::Job
  attr_accessible :subscription_id
  table_name = 'delayed_jobs'

  ReminderPriority = 5

  class DoseReminder < Struct.new(:subscription_id, :dose_id)
    
    # TODO: Error management
    # TODO: Send to all channels
    # TODO: Enqueue next dose if it is by interval
    def perform
      subscription = Subscription.find(subscription_id)
      return unless subscription.status_active?

      child = subscription.child
      dose = Dose.find(dose_id)
      SubscribersMailer.dose_reminder(child, dose).deliver
    end
  
  end

  def self.register_dose(opts={})
    subscription, dose, date = opts[:subscription], opts[:dose], opts[:date]
    offset = subscription.subscriber.time_offset
    run_at = DateTime.new(date.year, date.month, date.day, 10, 0, 0, offset)
    self.enqueue DoseReminder.new(subscription.id, dose.id), subscription_id: subscription.id, priority: ReminderPriority, run_at: run_at
  end

end