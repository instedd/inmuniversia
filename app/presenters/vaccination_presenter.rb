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

class VaccinationPresenter < Presenter
  delegate :id, :status, :status_text, :planned_age, to: :@vaccination
  
  display :id, :date, :date_string, :date_short, :child_name, :vaccine_name, :name, :status, :status_icon, :status_text

  def date
    Date.new(@vaccination.date.year, @vaccination.date.month, @vaccination.date.day)
  end

  def date_string
    I18n.l(date, format: :long)
  end

  def date_short
    I18n.l(date, format: :default)
  end

  def child_name
    @vaccination.child.name
  end

  def vaccine_name
    @vaccination.vaccine.name
  end

  def name
    @vaccination.dose.name
  end

  def full_description
    "#{name} de #{vaccine_name} a #{child_name}"
  end

  def vaccine_id
    @vaccination.vaccine.id
  end

  def vaccine_published
    @vaccination.vaccine.published
  end

  def full_description_part1
    "#{name} de "
  end

  def full_description_part2
    " a #{child_name}"
  end

  def status_icon
    "st-#{status}"
  end

  def initialize(vaccination)
    @vaccination = vaccination
  end

end