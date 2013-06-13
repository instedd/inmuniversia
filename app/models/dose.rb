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

class Dose < ActiveRecord::Base
  
  belongs_to :vaccine, class_name: '::Vaccine'
  has_many :vaccinations, dependent: :destroy

  acts_as_list scope: :vaccine, column: :number

  attr_accessible :age_unit, :age_value, :interval_unit, :interval_value, :name, :number

  def date_for(child)
    subclass_responsibility
  end

  def span
    subclass_responsibility
  end

  def vaccination_for(child)
    child.vaccinations.find{|v| v.dose == self}
  end

  def full_name
    "#{name} de #{vaccine.name}"
  end

  def previous_dose
    self.higher_item
  end

  def next_dose
    self.lower_item
  end

end
