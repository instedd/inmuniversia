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

class Reminder < ActiveRecord::Base
  extend Enumerize

  belongs_to :vaccination

  attr_accessible :sent_at, :status, :type

  enumerize :status, in: %w(pending sending sent expired), default: :pending, predicates: true

  acts_as_list scope: :vaccination, column: :number

  scope :pending, where(status: :pending)

  def send_at
    vaccination.planned_date + delta
  end

  def delta
    subclass_responsibility
  end

  def dose
    vaccination.try(:dose)
  end

end
