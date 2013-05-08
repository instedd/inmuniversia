
FactoryGirl.define do
  factory :disease, :class => Refinery::Vaccines::Disease do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

