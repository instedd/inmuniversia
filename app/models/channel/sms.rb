class Channel::Sms < Channel

  def do_send_reminders(reminders)
    response = nuntium.send_ao reminders.map{|r| message(r)}
  end

  protected

  def normalized_address
    address.gsub(/[^0-9]/, '')
  end

  def nuntium
    n = Settings.nuntium
    raise "Nuntium config not set, aborting SMS messages." if n.url.blank? || n.account.blank? || n.application.blank? || n.password.blank?
    return Nuntium.new(n.url, n.account, n.application, n.password)
  end

  def message(reminder)
    {from: "sms://#{Settings.nuntium.sms_from}", to: "sms://#{normalized_address}", body: body_for(reminder)}
  end

  def body_for(reminder)
    presenter = ReminderPresenter.new(reminder)
    return presenter.sms_text
  end

end