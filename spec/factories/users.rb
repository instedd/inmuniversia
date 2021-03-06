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
  factory :user do
    sequence(:email) { |n| "user.#{n}@example.com"}
    password "Password1!"

    factory :refinery_user do
      after(:create) do |user, evaluator|
        user.add_role(:refinery)
        user.add_role(:superuser)
      end
    end
  end
end
