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

FactoryGirl.define do
  factory :channel do
    association :subscriber
    notifications_enabled false
    verification_code nil

    factory :sms_channel, :class => "Channel::Sms" do
      sequence(:address) { |n| "555%04d" % n }
    end

    factory :email_channel, :class => "Channel::Email" do
      sequence(:address) { |n| "joe#{n}@example.com" }
    end
  end
end
