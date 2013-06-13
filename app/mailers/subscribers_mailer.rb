# encoding: utf-8
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

class SubscribersMailer < ActionMailer::Base
  default from: Settings.email.sender

  def reminder_upcoming_dose(reminder, address)    
    @reminder = ReminderPresenter.new(reminder)
    mail(to: address, subject: "Se aproxima la #{@reminder.dose_name} para #{@reminder.child_name}")
  end

  def reminder_current_dose(reminder, address)
    @reminder = ReminderPresenter.new(reminder)
    mail(to: address, subject: "Ya podés darle la #{@reminder.dose_name} a #{@reminder.child_name}")
  end

  def reminder_after_dose(reminder)
    @reminder = ReminderPresenter.new(reminder, address)
    mail(to: address, subject: "Ya deberías haberle dado #{@reminder.dose_name} a #{@reminder.child_name}")
  end

end
