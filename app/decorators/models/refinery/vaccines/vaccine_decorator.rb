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

Refinery::Vaccines::Vaccine.class_eval do
  has_and_belongs_to_many :diseases
  has_many :doses, order: :number, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  attr_accessible :disease_ids, :name

  scope :published, where(published: true)
  scope :defaults,  where(in_calendar: true)

  def next_dose_for(child)
    doses_given_ids = child.vaccinations_for(self).map(&:dose_id)
    doses.where("id NOT IN (?)", doses_given_ids).first
  end

  def self.setup(name, *doses_attrs)
    vaccine = self.where(name: name).first || self.create(name: name)
    vaccine.update_column :in_calendar, true
    doses_attrs.each do |attrs|
      vaccine.doses << DoseByAge.new(attrs)
    end
  end
end