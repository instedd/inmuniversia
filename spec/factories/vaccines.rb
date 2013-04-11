FactoryGirl.define do
  factory :vaccine do
    sequence(:name) { |n| "Vaccine #{n}" }
  end
end
