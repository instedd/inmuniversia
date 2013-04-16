FactoryGirl.define do
  factory :child do
    sequence(:name) {|n| "Joe #{n}"}
    date_of_birth "2013-04-10 16:52:57"
    gender "Male"
    parent

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
