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
