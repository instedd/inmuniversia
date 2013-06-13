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

class Subscription < ActiveRecord::Base
  
  extend Enumerize

  belongs_to :vaccine, class_name: '::Vaccine'
  belongs_to :child

  attr_accessible :status, :vaccine, :child

  enumerize :status, in: %w(active disabled), predicates: {prefix: true}, default: :active

  validates :vaccine_id, presence: true, uniqueness: {scope: :child_id}

  scope :active,   where(status: 'active')
  scope :disabled, where(status: 'disabled')

  def subscriber
    child.parent
  end

  def next_vaccination
    vaccinations.planned.sort_by(&:planned_date).first
  end

  def next_reminder_date
    vaccinations.planned.map(&:next_reminder_date).compact.min
  end

  def vaccinations
    child.vaccinations.where(vaccine_id: vaccine_id)
  end

end
