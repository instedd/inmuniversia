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

class VaccinationsController < AuthenticatedController

  before_filter :load_vaccination

  def update
    @vaccination.update_attributes params[:vaccination]
    date_format = %w(short long default month_year year).include?(params[:date_format]) ? params[:date_format].to_sym : params[:date_format] || :short
    render partial: "vaccinations/#{params[:render]}_entry", locals: {vaccination: VaccinationPresenter.new(@vaccination), date_format: date_format}
  end

  protected

  def load_vaccination
    @vaccination = current_subscriber.vaccinations.find(params[:id])
  end
  
end