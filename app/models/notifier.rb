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

class Notifier

  def self.start!
    puts "Starting notifier loop"
    while true
      sleep sleep_time
      Notifier.new.run!
    end
  end

  def self.sleep_time
    now = Time.now
    next_run = now.hour < 16 ? now.change(hour: 16) : now.tomorrow.change(hour: 16)
    next_run - now
  end

  def run!
    Subscriber.where("next_message_at <= ?", Date.today).each do |subscriber|
      notify_subscriber(subscriber)
    end
  end

  def notify_subscriber(subscriber)
    Subscriber.transaction do 
      reminders = collect_reminders_for(subscriber)
      send_reminders(reminders, subscriber) if reminders.any?
      subscriber.update_next_message_date!
    end
  end

  def send_reminders(reminders, subscriber)
    subscriber.channels.each do |channel|
      Notification.enqueue(channel, reminders, subscriber)
    end
  end

  protected

  def collect_reminders_for(subscriber)
    [].tap do |subscriber_reminders|
      
      subscriber.subscriptions.each do |subscription|
        
        vaccination = subscription.next_vaccination
        next if vaccination.nil?

        reminders = collect_vaccination_pending_reminders(vaccination)
        last_reminder = reminders.pop

        subscriber_reminders << last_reminder unless last_reminder.nil?
        
        mark_reminders reminders, as: 'expired'
        mark_vaccination_as_past(vaccination) if vaccination.reminders.last == last_reminder
      end

      mark_reminders subscriber_reminders, as: 'sending'
    end
  end

  def mark_reminders(reminders, opts={})
    reminders.each do |r|
      r.update_column :status, opts[:as]
    end
  end

  def collect_vaccination_pending_reminders(vaccination)
    vaccination.reminders.pending.select {|r| r.send_at <= Date.today}
  end

  def mark_vaccination_as_past(vaccination)
    vaccination.update_column(:status, 'past')
  end

end