class SubscribersMailer < ActionMailer::Base
  default from: "no-reply@inmuniversia.instedd.org"

  def dose_reminder(child, dose)
    @child = child
    @dose = dose
    @vaccine = dose.vaccine
    @subscriber = child.subscriber

    mail(to: @subscriber.email, subject: "#{dose.full_name.capitalize} para #{child.name}")
  end

end
