require 'spec_helper'

describe Subscriber do
  
  context "next message" do

    before(:each) { Timecop.freeze(Time.local(2013,1,1)) }
    after(:each)  { Timecop.return }

    let!(:subscriber)  { create(:subscriber) }
    
    let!(:vaccine_one) { create(:vaccine, :with_doses, first_dose_at: 1) }
    let!(:vaccine_two) { create(:vaccine, :with_doses, first_dose_at: 2) }

    it "should calculate next message date with one child" do
      create(:child, :with_vaccinations, :with_subscriptions, parent: subscriber, date_of_birth: Date.new(2012,6,10))
      subscriber.update_next_message_date!.should be_during(2013,6)
    end

    it "should calculate next message date with multiple children" do
      create(:child, :with_vaccinations, :with_subscriptions, parent: subscriber, date_of_birth: Date.new(2012,6,10))
      create(:child, :with_vaccinations, :with_subscriptions, parent: subscriber, date_of_birth: Date.new(2012,4,10))

      subscriber.update_next_message_date!.should be_during(2013,4)
    end

    it "should calculate next message date exactly one week before planned vaccination" do
      create(:child, :with_vaccinations, :with_subscriptions, parent: subscriber, date_of_birth: Date.new(2012,6,10))
      subscriber.update_next_message_date!.should be_during(2013,6,3)
    end

  end

end
