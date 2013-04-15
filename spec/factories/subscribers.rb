FactoryGirl.define do
  factory :subscriber, aliases: [:parent] do
    sequence(:email) { |n| "subscriber.#{n}@example.com"}
    password "Password1!"
  end
end
