FactoryGirl.define do
  factory :subscriber, aliases: [:parent] do
    sequence(:email) { |n| "subscriber.#{n}@example.com"}
    first_name "John"
    last_name "Doe"
    zip_code "12345"
    password "Password1!"
  end
end
