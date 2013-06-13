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
  factory :child do
    sequence(:name) {|n| "Joe #{n}"}
    date_of_birth "2013-01-1"
    gender "male"
    parent

    trait :with_setup do
      after(:create) do |child, evaluator|
        child.setup!
      end
    end

    trait :with_vaccinations do
      after(:create) do |child, evaluator|
        child.create_vaccinations!
      end
    end

    trait :with_subscriptions do
      after(:create) do |child, evaluator|
        child.subscribe!
      end
    end

  end
end
