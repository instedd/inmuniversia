class Channel::Email < Channel

  def do_send_reminders(reminders, subscriber)
    reminders.each do |reminder|
      SubscribersMailer.send(reminder.class.name.underscore, reminder, address).deliver
    end
  end

end