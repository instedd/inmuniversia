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

class Channel < ActiveRecord::Base
  belongs_to :subscriber

  attr_accessible :notifications_enabled, :address, :verification_code

  validates :address, presence: true

  scope :sms,   where(type: 'Channel::Sms')
  scope :email, where(type: 'Channel::Email')

  def send_reminders(reminders)
    do_send_reminders(reminders)
    reminders.update_all(status: 'sent', sent_at: DateTime.now)
  end

  def to_partial_path
    "channels/#{self.class.name.split(/::/).last.underscore}"
  end

  protected

  def do_send_reminders(reminders)
    subclass_responsibility
  end

end
