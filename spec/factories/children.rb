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
