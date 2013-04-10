require 'spec_helper'

describe Child do
  
  context "on creation" do
    
    let(:vaccine) { create(:vaccine) }
    let(:child)   { create(:child, date_of_birth: Date.new(2000, 5, 10)) }

    before(:each) do
      Timecop.freeze(Time.local(2010,1,1))
    end

    after(:each) do
      Timecop.return
    end

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

end
