# encoding: utf-8

class Channel::Sms < Channel

  validate :address_should_be_a_phone_number

  def do_send_reminders(reminders)
    response = nuntium.send_ao reminders.map{|r| message(r)}
  end

  def address_should_be_a_phone_number
    errors.add(:address, "Debe ingresar un numero telefonico valido") if !address.nil? && (address.match /[^0-9 .-]/)
  end

  def address= value
    value = value[/\d+/] if value.match /^sms:\/\//i
    value.strip!
    write_attribute(:address, value)
  end

  def address
    if self.read_attribute(:address).strip != self.read_attribute(:address)
      write_attribute(:address, self.read_attribute(:address).strip)
      self.save
    end
    self.read_attribute(:address)
  end

  def generate_verification_code
    self.verification_code ||= rand(999999)
  end

  def send_verification_code
    generate_verification_code.tap do |code|
      puts "Verification code is: #{code}" if Rails.env.development?
      nuntium.send_ao message("Su código de verificación en Inmuniversia es: #{code}")
    end
  end

  def send_message message
    nuntium.send_ao message(message)
  end

  def verify code
    if verification_code == code
      self.verification_code = "verified"
      save!
    end
  end


  protected

  class NuntiumStub
    def send_ao(message_or_messages)
      puts "Sending via Nuntium: #{Array.wrap(message_or_messages).map(&:inspect).join('\n')}"
    end
  end

  def normalized_address
    address.gsub(/[^0-9]/, '')
  end

  def nuntium
    n = Settings.nuntium
    return NuntiumStub.new if not n.enabled
    raise "Nuntium config not set, aborting SMS messages." if n.url.blank? || n.account.blank? || n.application.blank? || n.password.blank?
    return Nuntium.new(n.url, n.account, n.application, n.password)
  end

  def message(reminder_or_text)
    body = reminder_or_text.is_a?(String) ? reminder_or_text : body_for(reminder_or_text)
    {from: "sms://#{Settings.nuntium.sms_from}", to: "sms://#{normalized_address}", body: body}
  end

  def body_for(reminder)
    presenter = ReminderPresenter.new(reminder)
    return presenter.sms_text
  end

end