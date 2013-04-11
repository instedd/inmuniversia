# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    vaccine nil
    child nil
    status "MyString"
  end
end
