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
  factory :vaccine do
    sequence(:name) { |n| "Vaccine #{n}" }
    published true
    in_calendar true

    trait :with_doses do
      ignore { dose_count 3 }
      ignore { first_dose_at 1 }

      after(:create) do |vaccine, evaluator|
        evaluator.dose_count.times do |i|
          create(:dose_by_age, age_value: (i + evaluator.first_dose_at), age_unit: 'year', vaccine: vaccine)
        end
      end
    end

    trait :with_monthly_doses do
      ignore { dose_count 3 }
      ignore { first_dose_at 1 }

      after(:create) do |vaccine, evaluator|
        evaluator.dose_count.times do |i|
          create(:dose_by_age, age_value: (i + evaluator.first_dose_at), age_unit: 'month', vaccine: vaccine)
        end
      end
    end

  end
end
