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

module VaccinationHelper

  def render_vaccination_status(vaccination)
    render 'vaccinations/status_dropdown', vaccination: vaccination
  end

  def render_agenda_entry(vaccination, opts)
    section = opts[:section]
    render 'vaccinations/agenda_entry', vaccination: vaccination, date_format: section.vaccination_date_format
  end

  def vaccination_status_icon(status)
    content_tag :i, '', class: "st-#{status}"
  end

end