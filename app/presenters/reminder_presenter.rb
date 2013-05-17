# encoding: UTF-8

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

  def sms_text
    case reminder
    when ReminderUpcomingDose
      "A partir del #{dose_date.to_formatted_s(:long)} corresponde la aplicación de la #{dose_name} a #{child_name} | #{Settings.hosts.local}"
    when ReminderCurrentDose
      "Ya corresponde la aplicación de la #{@reminder.dose_name} a #{@reminder.child_name} | #{Settings.hosts.local}"
    when ReminderAfterDose
      "Ya deberías haberle aplicado la #{@reminder.dose_name} a #{@reminder.child_name} | #{Settings.hosts.local}"
    end
  end

end