# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vaccination do
    child_id 1
    dose_id 1
    vaccine_id 1
    date "2013-04-10"
  end
end
