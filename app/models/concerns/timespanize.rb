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

module Concerns::Timespanize

  def self.extended(base)
    base.send(:extend, Enumerize)
  end

  def timespanize(field_name, opts={})
    value_field =   opts.fetch(:value, "#{field_name}_value")
    unit_field =    opts.fetch(:unit, "#{field_name}_unit")
    
    unit_values =   opts.fetch(:unit_values, [:year, :month, :week])
    unit_default =  opts.fetch(:unit_default, :year)
    
    end_method =    opts.fetch(:end, "#{field_name}_end")
    desc_method =   opts.fetch(:description, "#{field_name}_description")
    includes_method = opts.fetch(:includes, "#{field_name}_includes?")

    enumerize unit_field, in: unit_values, default: unit_default

    define_method(field_name) do
      value = send(value_field)
      unit = send(unit_field)
      value && unit && value.send(unit)
    end

    define_method(end_method) do
      unit = send(unit_field)
      send(field_name) + 1.send(unit)
    end

    define_method(desc_method) do
      value = send(field_name)
      value.nil? ? "" : value.inspect
    end

    define_method(includes_method) do |value|
      send(field_name) <= value && send(end_method) >= value
    end
  end

end