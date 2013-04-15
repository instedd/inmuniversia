FactoryGirl.define do
  factory :child do
    sequence(:name) {|n| "Joe #{n}"}
    date_of_birth "2013-04-10 16:52:57"
    gender "Male"
    parent
  end
end
