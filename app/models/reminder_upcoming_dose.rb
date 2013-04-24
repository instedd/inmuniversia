class ReminderUpcomingDose < Reminder

  def delta
    -1.week
  end

end