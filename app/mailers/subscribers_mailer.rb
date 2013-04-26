# encoding: utf-8
class SubscribersMailer < ActionMailer::Base
  default from: Settings.email.sender

  def reminder_upcoming_dose(reminder, address)    
    @reminder = ReminderPresenter.new(reminder)
    mail(to: address, subject: "Se aproxima la #{@reminder.dose_name} para #{@reminder.child_name}")
  end

  def reminder_current_dose(reminder, address)
    @reminder = ReminderPresenter.new(reminder)
    mail(to: address, subject: "Ya podés darle la #{@reminder.dose_name} a #{@reminder.child_name}")
  end

  def reminder_after_dose(reminder)
    @reminder = ReminderPresenter.new(reminder, address)
    mail(to: address, subject: "Ya deberías haberle dado #{@reminder.dose_name} a #{@reminder.child_name}")
  end

end
