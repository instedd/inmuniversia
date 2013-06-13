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

class Vaccination < ActiveRecord::Base
  
  extend Enumerize
  extend Concerns::Timespanize

  belongs_to :vaccine, :class_name => '::Vaccine'
  belongs_to :dose
  belongs_to :child

  has_many :reminders, dependent: :destroy

  scope :planned, where(status: :planned)
  scope :taken,   where(status: :taken)
  scope :past,    where(status: :past)
  scope :future,  where('status = ? OR status = ?', :planned, :taken)

  enumerize :status, in: %w(planned taken past cancelled), predicates: true, default: 'planned'

  timespanize :planned_age, unit_default: nil

  attr_accessible :child_id, :dose_id, :vaccine_id, :taken_at, :planned_age_value, :planned_age_unit, :status
  attr_accessible :child, :vaccine, :dose

  after_create :create_reminders!

  before_save do |vaccination|
    if vaccination.dose
      vaccination.planned_age_value ||= vaccination.dose.age_value
      vaccination.planned_age_unit ||= vaccination.dose.age_unit
      vaccination.vaccine ||= vaccination.dose.vaccine
    end
  end

  def date
    taken_at || planned_date
  end

  def next_reminder
    reminders.pending.first
  end

  def next_reminder_date
    next_reminder.try(:send_at)
  end

  def planned_date
    child.date_of_birth + planned_age
  end

  protected

  # TODO: Define how reminders are to be managed and created, they should depend on the dose
  def create_reminders!
    reminders << ReminderUpcomingDose.new
    reminders << ReminderCurrentDose.new
    reminders << ReminderAfterDose.new
  end

end
