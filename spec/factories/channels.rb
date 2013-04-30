FactoryGirl.define do
  factory :channel do
    association :subscriber
    notifications_enabled false
    verification_code nil

    factory :sms_channel, :class => "Channel::Sms" do
      sequence(:address) { |n| "555%04d" % n }
    end

    factory :email_channel, :class => "Channel::Email" do
      sequence(:address) { |n| "joe#{n}@example.com" }
    end
  end
end
