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
  
  end
end
