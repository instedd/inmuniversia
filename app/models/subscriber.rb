class Subscriber < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :next_message_at, :first_name, :last_name, :zip_code, :sms_only

  serialize :preferences, Hash

  validates_presence_of :first_name, :last_name, :zip_code, unless: :sms_only

  has_many :children, inverse_of: :parent, foreign_key: :parent_id
  has_many :subscriptions, through: :children
  has_many :vaccinations, through: :children

  has_many :channels, dependent: :destroy

  has_many :email_channels, class_name: "Channel::Email", dependent: :destroy
  has_many :sms_channels,   class_name: "Channel::Sms",   dependent: :destroy

  before_create :build_email_channel

  def self.create_sms_subscriber phone_number
    subscriber = self.new(sms_only: true)
    subscriber.sms_channels.build(address: phone_number, notifications_enabled: true)
    subscriber.save
    subscriber
  end

  def active_for_authentication?
    super && !sms_only
  end

  def email_required?
    super && !sms_only
  end

  def password_required?
    super && !sms_only
  end

  def time_offset
    '-3'
  end

  def full_name
    ([first_name, last_name].compact.presence || [email]).join(" ")
  end

  def update_next_message_date!
    subscriptions.map(&:next_reminder_date).compact.min.tap do |next_reminder_date|
      update_column :next_message_at, next_reminder_date if next_reminder_date != next_message_at
    end
  end

  def build_email_channel
    email_channels.build(address: email, notifications_enabled: true)
  end

end
