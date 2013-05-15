class Subscriber < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :next_message_at, :first_name, :last_name, :zip_code

  serialize :preferences, Hash

  validates_presence_of :first_name, :last_name, :zip_code

  has_many :children, inverse_of: :parent, foreign_key: :parent_id
  has_many :subscriptions, through: :children
  has_many :vaccinations, through: :children

  has_many :channels, dependent: :destroy

  has_many :email_channels, class_name: "Channel::Email", dependent: :destroy
  has_many :sms_channels,   class_name: "Channel::Sms",   dependent: :destroy

  before_create :build_email_channel

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
