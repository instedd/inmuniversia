require 'spec_helper'

describe Subscription do
  
  context "validations" do

    it "cannot create more than one subscription for the same child and vaccine" do
      child, vaccine = create(:child), create(:vaccine)
      create(:subscription, child: child, vaccine: vaccine)
      
      expect {
        duplicated_subscription = build(:subscription, child: child, vaccine: vaccine)
        duplicated_subscription.save.should be_false
      }.to change(Subscription, :count).by(0)
    end

  end

  context "notifications" do

    before(:each) { Timecop.freeze(Time.local(2013,1,1)) }
    after(:each)  { Timecop.return }

    let(:parent)  { create(:subscriber, email: 'jdoe@example.com')}
    let(:child)   { create(:child, parent: parent, date_of_birth: Date.new(2010, 5, 10)) }
    
    let!(:vaccine) do 
      create(:vaccine).tap do |vaccine|
        create(:dose_by_age, age_value: 2, vaccine: vaccine)
        create(:dose_by_age, age_value: 5, vaccine: vaccine)
        create(:dose_by_age, age_value: 10, vaccine: vaccine)
        create(:vaccination, child: child, dose: vaccine.doses.first)
      end
    end
    
    it "should generate notifications for all pending doses" do
      subscription = nil
      
      expect {
        subscription = Subscription.create!(child: child, vaccine: vaccine)
      }.to change(Delayed::Job, :count).by(2)

      Delayed::Job.count.should eq(2)

      Delayed::Job.all[0].tap do |job|
        job.run_at.year.should eq(2015)
        job.run_at.should eq(DateTime.new(2015,5,10,10,0,0,'-3'))
        job.subscription_id.should eq(subscription.id)
      end

      Delayed::Job.all[1].tap do |job|
        job.run_at.year.should eq(2020)
        job.run_at.should eq(DateTime.new(2020,5,10,10,0,0,'-3'))
        job.subscription_id.should eq(subscription.id)
      end
    end

  end

end
