require 'spec_helper'

describe Child do
  
  context "creating vaccinations" do

    let(:vaccine) { create(:vaccine) }
    let(:child)   { create(:child, date_of_birth: Date.new(2000, 5, 10)) }

    before(:each) { Timecop.freeze(Time.local(2010,1,1)) }
    after(:each)  { Timecop.return }


    it "should create vaccinations with vaccine with doses by age" do
      doses = [
        create(:dose_by_age, vaccine: vaccine, age_value: 5),
        create(:dose_by_age, vaccine: vaccine, age_value: 8),
        create(:dose_by_age, vaccine: vaccine, age_value: 12)
      ]

      expect {
        child.create_vaccinations!
      }.to change(Vaccination, :count).by(3)

      child.should have(3).vaccinations

      child.vaccinations[0].tap do |v|
        v.dose.should eq(doses[0])
        v.planned_date.should eq(Date.new(2005,5,10))
        v.should be_past
      end

      child.vaccinations[1].tap do |v|
        v.dose.should eq(doses[1])
        v.planned_date.should eq(Date.new(2008,5,10))
        v.should be_past
      end

      child.vaccinations[2].tap do |v|
        v.dose.should eq(doses[2])
        v.planned_date.should eq(Date.new(2012,5,10))
        v.should be_planned
      end
    end


    it "should create vaccinations with vaccine with doses by age and by interval" do
      doses = [
        create(:dose_by_age, vaccine: vaccine, age_value: 4),
        create(:dose_by_interval, vaccine: vaccine, interval_value: 5),
        create(:dose_by_interval, vaccine: vaccine, interval_value: 2)
      ]

      expect {
        child.create_vaccinations!
      }.to change(Vaccination, :count).by(3)

      child.should have(3).vaccinations

      child.vaccinations[0].tap do |v|
        v.dose.should eq(doses[0])
        v.planned_date.should eq(Date.new(2004,5,10))
        v.should be_past
      end

      child.vaccinations[1].tap do |v|
        v.dose.should eq(doses[1])
        v.planned_date.should eq(Date.new(2009,5,10))
        v.should be_past
      end

      child.vaccinations[2].tap do |v|
        v.dose.should eq(doses[2])
        v.planned_date.should eq(Date.new(2011,5,10))
        v.should be_planned
      end
    end

  end


  context "subscribing" do

    let(:child)     { create(:child, date_of_birth: Date.new(2000, 5, 10)) }
    let!(:vaccines) { create_list(:vaccine, 3) }

    it "should create subscription for vaccines" do
      expect { 
        child.subscribe!
      }.to change(Subscription, :count).by(3)

      child.should have(3).subscriptions
      child.subscriptions.map(&:vaccine_id).should eq(vaccines.map(&:id))
    end

    it "should not create subscription for vaccines already subscribed" do
      create(:subscription, child: child, vaccine: vaccines.first)

      expect { 
        child.subscribe!
      }.to change(Subscription, :count).by(2)

      child.should have(3).subscriptions
      child.reload.should have(3).subscriptions
      child.subscriptions.map(&:vaccine_id).should eq(vaccines.map(&:id))
    end

  end
  
end
