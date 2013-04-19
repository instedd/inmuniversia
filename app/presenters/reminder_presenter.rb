class ReminderPresenter

  def initialize(reminder)
    @reminder = reminder
  end

  def subscriber_name
    @reminder.vaccination.child.subscriber.full_name
  end

  def dose_name
    @reminder.vaccination.dose.full_name
  end

  def dose_date
    @reminder.vaccination.planned_date
  end

  def child_name
    @reminder.vaccination.child.name
  end

end