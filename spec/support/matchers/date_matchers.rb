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

RSpec::Matchers.define :be_during do |year, month, day|
  match do |actual|
    actual &&\
    (year.nil?  || actual.year == year) &&\
    (month.nil? || actual.month == month) &&\
    (day.nil?   || actual.day == day)
  end

  def build_description(year, month, day)
    "be during " + [year && "year #{year}", month && "month #{month}", day && "day #{day}"].compact.join(", ")
  end

  description do 
    build_description(year, month, day)
  end

  failure_message_for_should do |actual|
    "expected #{actual || actual.inspect} to #{build_description(year, month, day)}"
  end

  failure_message_for_should_not do |actual|
    "expected #{actual || actual.inspect} not to #{build_description(year, month, day)}"
  end

end