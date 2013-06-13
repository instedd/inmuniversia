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

module Refinery
  module Vaccines
    class Vaccine < Refinery::Core::BaseModel
      self.table_name = 'refinery_vaccines'

      attr_accessible :name, :general_info, :commercial_name, :doses_info, :recommendations, :side_effects, :more_info, :published, :position, :in_calendar

      acts_as_indexed :fields => [:name, :general_info, :commercial_name, :doses_info, :recommendations, :side_effects, :more_info]

      validates :name, :presence => true, :uniqueness => true
    end
  end
end
Vaccine