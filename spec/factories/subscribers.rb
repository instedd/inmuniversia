FactoryGirl.define do
  factory :subscriber do
    sequence(:email) { |n| "subscriber.#{n}@example.com"}
    password "Password1!"
  end
end
