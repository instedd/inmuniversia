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

class Notifier::Notification < Struct.new(:channel_id, :reminders_ids, :subscriber_id)

  def initialize(channel, reminders, subscriber)
    self.reminders_ids = reminders.map(&:id)
    self.subscriber_id = subscriber.id
    self.channel_id = channel.id
  end

  def perform
    channel = Channel.find(self.channel_id)
    subscriber = Subscriber.find(self.subscriber_id)
    reminders = Reminder.where(id: self.reminders_ids)
    
    # TODO: Validate if these subscriber, channel and reminders are still elligible for sending
    return unless channel && subscriber && reminders.any?
    channel.send_reminders(reminders)
  end

  def self.enqueue(channel, reminders, subscriber)
    self.new(channel, reminders, subscriber).tap do |notification|
      Delayed::Job.enqueue(notification)
    end
  end

end