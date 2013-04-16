class ReminderUpcomingDose < Reminder

  def send_at
    vaccination.planned_date - 1.week
  end

end