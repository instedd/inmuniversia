FactoryGirl.define do
  factory :disease do
    sequence(:name) { |n| "Disease #{n}" }
    published true
  end
end
