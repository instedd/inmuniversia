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

class VaccinePresenter < Presenter
  delegate :name, :published, :diseases, to: :@vaccine
  delegate :id, :status, :status_active?, :status_disabled?, to: :@subscription

  def initialize(vaccine, opts={})
    @vaccine = vaccine
    @subscription = opts[:subscription]
  end

  def diseases_list
    diseases.map(&:name).join(", ")
  end

  def subscription_id
    @subscription.id
  end

  def vaccine_id
    @vaccine.id
  end

  def vaccinations
    @vaccinations ||= VaccinationPresenter.present(@subscription.vaccinations)
  end

  def enabled
    status_active?
  end

  def persisted?
    true
  end

end