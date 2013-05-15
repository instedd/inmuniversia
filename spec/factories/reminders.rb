FactoryGirl.define do
  factory :reminder do
    association :vaccination, factory: 'vaccination'
    status "pending"

    factory :reminder_upcoming_dose, :class => "ReminderUpcomingDose"
    factory :reminder_current_dose, :class => "ReminderCurrentDose"
    factory :reminder_after_dose, :class => "ReminderAfterDose"
  end
end
