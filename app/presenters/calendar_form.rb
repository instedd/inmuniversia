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

class CalendarForm

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  delegate :id, :name, :name=, :date_of_birth, :date_of_birth=, to: :child, prefix: true

  def initialize(calendar)
    @calendar = calendar
  end

  def id
    child_id
  end

  def child
    @calendar.child
  end

  def persisted?
    true # Calendar forms are only for updates
  end

  def self.model_name
    ActiveModel::Name.new(CalendarForm, nil, "Calendar")
  end

  def save
    child.save && save_vaccines
  end

  def update_attributes(attributes)
    set_attributes(attributes)
    save
  end

  def vaccines
    @calendar.vaccines
  end

  def vaccines_attributes=(attributes_array)
    @vaccines_attributes= attributes_array
  end

  protected

  def set_attributes(attributes)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def save_vaccines
    @vaccines_attributes.blank? or @vaccines_attributes.all? do |index, attributes|
      subscription = find_subscription(attributes[:subscription_id])
      status = attributes.get_bool(:enabled) ? 'active' : 'disabled'
      subscription.update_column(:status, status)
    end
  end

  def find_subscription(id)
    @calendar.subscriptions.find{|s| s.id.to_i == id.to_i}
  end

end