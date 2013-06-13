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

FactoryGirl.define do
  factory :reminder do
    association :vaccination, factory: 'vaccination'
    status "pending"

    factory :reminder_upcoming_dose, :class => "ReminderUpcomingDose"
    factory :reminder_current_dose, :class => "ReminderCurrentDose"
    factory :reminder_after_dose, :class => "ReminderAfterDose"
  end
end
