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

class CalendarPresenter

  attr_accessor :child, :vaccines, :timespans, :subscriptions

  def initialize(child)
    @child = child

    @subscriptions =     load_subscriptions
    @vaccines =          load_vaccines
    @timespans =         load_timespans
    @vaccination_slots = load_vaccination_slots
  end

  def vaccinations_for(vaccine)
    @vaccination_slots[vaccine]
  end

  def vaccinations_with_timespans_for(vaccine)
    vaccinations_for(vaccine).zip(timespans)
  end

  def active_vaccines
    @vaccines.select(&:status_active?)
  end

  def vaccines
    @vaccines
  end

  def form
    CalendarForm.new(self)
  end

  protected

  def load_subscriptions
    child.subscriptions.to_a
  end

  def load_timespans
    # TODO: Detect overlaps in timestamps
    # HACK: Array#uniq does not use eql? or == for equality, therefore the uniqueness check is made manually
    timespans = []
    @subscriptions.select(&:status_active?).map(&:vaccinations).flatten.each do |vaccination|
      timespan = Timespan.new(vaccination.planned_age_value, vaccination.planned_age_unit, child.date_of_birth)
      timespans << timespan unless timespans.include?(timespan)
    end
    timespans << CurrentTimespan.new unless timespans.any?(&:current?)
    return timespans.sort
  end

  def load_vaccination_slots
    vaccination_slots = {}
    active_vaccines.each do |vaccine|
      vaccination_slots[vaccine] = load_vaccination_slots_for(vaccine)
    end

    return vaccination_slots
  end

  def load_vaccination_slots_for(vaccine)
    slots = [nil] * timespans.length
    vaccine.vaccinations.each do |vaccination|
      index = timespans.index {|t| vaccination.planned_age == t.age}
      slots[index] = vaccination
    end

    return slots
  end

  def load_vaccines
    @subscriptions.map do |subscription|
      VaccinePresenter.new(subscription.vaccine, subscription: subscription)
    end
  end

end