# encoding: UTF-8

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

class ReminderPresenter

  def initialize(reminder)
    @reminder = reminder
  end

  def subscriber_name
    @reminder.vaccination.child.subscriber.full_name
  end

  def dose_name
    @reminder.vaccination.dose.full_name
  end

  def dose_date
    @reminder.vaccination.planned_date
  end

  def child_name
    @reminder.vaccination.child.name
  end

  def sms_text
    case reminder
    when ReminderUpcomingDose
      "A partir del #{dose_date.to_formatted_s(:long)} corresponde la aplicación de la #{dose_name} a #{child_name} | #{Settings.hosts.local}"
    when ReminderCurrentDose
      "Ya corresponde la aplicación de la #{@reminder.dose_name} a #{@reminder.child_name} | #{Settings.hosts.local}"
    when ReminderAfterDose
      "Ya deberías haberle aplicado la #{@reminder.dose_name} a #{@reminder.child_name} | #{Settings.hosts.local}"
    end
  end

end