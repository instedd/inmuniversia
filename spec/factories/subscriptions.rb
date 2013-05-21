FactoryGirl.define do
  factory :subscription do
    vaccine
    child
    status "active"
  end
end
