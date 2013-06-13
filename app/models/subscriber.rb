# Copyright (C) 2013, InSTEDD
#
# This file is part of Inmuniversia.
#
# Inmuniversia is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Inmuniversia is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Inmuniversia.  If not, see <http://www.gnu.org/licenses/>.

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

  before_create :build_email_channel, unless: :sms_only

  def self.create_sms_subscriber phone_number
    subscriber = self.new(sms_only: true)
    subscriber.sms_channels.build(address: phone_number.to_s, notifications_enabled: true, verification_code: "verified")
    subscriber.save!
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

  def self.create_sms_with_children
    names_m = ["Josecito","Mario", "Ernestito", "Peter", "Arnaldo"]
    names_f = ["Maria", "Florencia", "Victoria", "Yolanda", "Yesica"]

    subscriber = Subscriber.create_sms_subscriber(rand(9999999999))
    child1 = subscriber.children.build name: names_m.sample, date_of_birth: rand(3.years).ago, gender: "male"

    child1.setup! if child1.save

    child2 = subscriber.children.build name: names_f.sample, date_of_birth: rand(3.years).ago, gender: "female"

    child2.setup! if child2.save

    subscriber
  end

end
