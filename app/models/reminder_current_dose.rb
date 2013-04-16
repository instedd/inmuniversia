class ReminderCurrentDose < Reminder

  def send_at
    vaccination.planned_date
  end

end