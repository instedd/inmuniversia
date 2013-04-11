require 'spec_helper'

describe Child do
  
  context "when assuming vaccinations" do

    let(:vaccine) { create(:vaccine) }
    let(:child)   { create(:child, date_of_birth: Date.new(2000, 5, 10)) }

    before(:each) { Timecop.freeze(Time.local(2010,1,1)) }
    after(:each)  { Timecop.return }


    it "should assume to be vaccinated until today for doses by age" do
      doses = [
        create(:dose_by_age, vaccine: vaccine, age_value: 5),
        create(:dose_by_age, vaccine: vaccine, age_value: 8),
        create(:dose_by_age, vaccine: vaccine, age_value: 12)
      ]

      expect {
        child.assume_vaccinated_until_today!
      }.to change(Vaccination, :count).by(2)

      child.should have(2).vaccinations

      child.vaccinations[0].tap do |v|
        v.dose.should eq(doses[0])
        v.date.should eq(Date.new(2005,5,10))
      end

      child.vaccinations[1].tap do |v|
        v.dose.should eq(doses[1])
        v.date.should eq(Date.new(2008,5,10))
      end
    end

    it "should assume to be vaccinated until today for complex doses" do
      doses = [
        create(:dose_by_age, vaccine: vaccine, age_value: 4),
        create(:dose_by_interval, vaccine: vaccine, interval_value: 5),
        create(:dose_by_interval, vaccine: vaccine, interval_value: 2)
      ]

      expect {
        child.assume_vaccinated_until_today!
      }.to change(Vaccination, :count).by(2)

      child.should have(2).vaccinations

      child.vaccinations[0].tap do |v|
        v.dose.should eq(doses[0])
        v.date.should eq(Date.new(2004,5,10))
      end

      child.vaccinations[1].tap do |v|
        v.dose.should eq(doses[1])
        v.date.should eq(Date.new(2009,5,10))
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

  context "vaccinations" do

    let(:child)    { create(:child, date_of_birth: Date.new(2000, 5, 10)) }
    let!(:vaccine) { create(:vaccine_with_doses_by_age) }
    let!(:vaccination) { create(:vaccination, child: child, dose: vaccine.doses.first) }

    it "should return pending doses for a vaccine based on last vaccination" do
      child.reload.pending_doses_for(vaccine).tap do |doses|
        doses.should have(2).items
        doses.should eq(vaccine.doses[1..2])
      end
    end

  end
  
end
