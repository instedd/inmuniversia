
FactoryGirl.define do
  factory :vaccine, :class => Refinery::Vaccines::Vaccine do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

