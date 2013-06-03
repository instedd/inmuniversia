class Channel::Email < Channel
  scope :verified, scoped

  def do_send_reminders(reminders)
    reminders.each do |reminder|
      SubscribersMailer.send(reminder.class.name.underscore, reminder, address).deliver
    end
  end

end