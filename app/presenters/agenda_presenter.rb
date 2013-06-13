# encoding UTF-8

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

class AgendaPresenter

  attr_accessor :sections

  def initialize(subscriber)
    @today = Date.today
    @subscriber = subscriber
    @sections = load_sections
  end


  protected


  def load_sections
    @current_section = initialize_current_section
    @past_section =    build_past_section

    @monthly_sections = Hash.new do |h, key|
      year, month = key
      h[key] = MonthSection.new(month: month, year: year, today: @today)
    end

    @yearly_sections = Hash.new do |h, key|
      year = key
      h[key] = YearSection.new(year: year, today: @today)
    end

    @subscriber.vaccinations.future.to_a.sort_by(&:planned_date).each do |vaccination|
      section_for(vaccination).vaccinations << VaccinationPresenter.new(vaccination)
    end

    sections = [@past_section, @current_section] + @monthly_sections.sort.map{|k,v| v} + @yearly_sections.sort.map{|k,v| v}
    sections.reject(&:empty?)
  end

  def build_past_section
    PastSection.new title: "Vencidas",
      vaccinations: VaccinationPresenter.present(@subscriber.vaccinations.past.to_a.sort_by(&:planned_date))
  end

  def initialize_current_section
    Section.new title: "Este mes"
  end

  def section_for(vaccination)
    date = vaccination.planned_date
    diff = (date - @today).days

    if date < @today.end_of_month
      @current_section
    elsif diff < 6.months
      @monthly_sections[[date.year, date.month]]
    else 
      @yearly_sections[date.year]
    end
  end

end