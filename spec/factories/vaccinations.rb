# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vaccination do
    child
    dose
    vaccine { dose.vaccine }
  end
end
