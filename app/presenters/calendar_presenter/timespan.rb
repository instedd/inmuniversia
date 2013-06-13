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

class CalendarPresenter::Timespan
  include Comparable
  extend Concerns::Timespanize

  timespanize :age
  
  attr_accessor :age_unit
  attr_accessor :age_value
  attr_accessor :dob

  def self.from(vaccination)
    self.new(vaccination.planned_age_value, vaccination.planned_age_unit, vaccination.child.date_of_birth)
  end

  def initialize(age_value, age_unit, dob)
    self.age_value = age_value
    self.age_unit = age_unit
    self.dob = dob
  end

  def <=>(other)
    [self.year, self.month] <=> [other.year, other.month]
  end

  def ==(other)
    self.age == other.age
  end

  def year
    (self.dob + age).year
  end

  def month
    (self.dob + age).month
  end

  def month_name
    Date.new(year, month).strftime("%B")
  end

  def current?
    today = Date.today
    [year, month] == [today.year, today.month]
  end

  def empty?
    false
  end

end