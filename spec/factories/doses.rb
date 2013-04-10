FactoryGirl.define do
  factory :dose do
    age_value 1
    age_unit "years"
    order 1
    name "Initial"
    interval_value 1
    interval_unit "years"
    type "DoseByAge"
  end
end
