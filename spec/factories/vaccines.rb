FactoryGirl.define do
  factory :vaccine do
    sequence(:name) { |n| "Vaccine #{n}" }

    factory :vaccine_with_doses_by_age do
      ignore { doses_count 3 }
      after(:create) do |vaccine, evaluator|
        evaluator.doses_count.times do |i|
          create(:dose_by_age, age_value: (i+1), vaccine: vaccine)
        end
      end
    end
  end
end
