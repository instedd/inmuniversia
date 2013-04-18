FactoryGirl.define do
  factory :dose do
    sequence(:number)
    name { "Dose #{number}" }

    association :vaccine, factory: 'vaccine'

    factory :dose_by_age, :class => 'DoseByAge' do
      age_value 1
      age_unit "years"
    end

  end
end
