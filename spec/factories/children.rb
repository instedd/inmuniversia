# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :child do
    name "MyString"
    date_of_birth "2013-04-10 16:52:57"
    gender "MyString"
    parent_id 1
  end
end
