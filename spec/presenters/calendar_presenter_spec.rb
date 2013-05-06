require 'spec_helper'

describe CalendarPresenter do

  let(:child)     { create(:child, :with_setup, date_of_birth: Date.new(2012,6,15)) }
  let(:presenter) { CalendarPresenter.new(child) }  

  before(:each) { Timecop.freeze(Time.utc(2013,6,10,12,0,0)) }

  context "with single vaccine" do
    let!(:vaccine) { create(:vaccine, :with_doses) }
    let(:doses)    { vaccine.doses }
    
    it "should generate timespan column headers" do
      presenter.should have(3).timespans
      
      presenter.timespans.tap do |t0,t1,t2|
        t0.year.should eq(2013)
        t0.month.should eq(6)
        t0.should be_current
        
        t1.year.should eq(2014)
        t1.month.should eq(6)
        
        t2.year.should eq(2015)
        t2.month.should eq(6)
      end
    end

    it "should generate empty timespan for current date if not included in existing timespans" do
      Timecop.freeze(Time.utc(2013,8,10))

      presenter.should have(4).timespans
      
      presenter.timespans[1].tap do |current|
        current.year.should eq(2013)
        current.month.should eq(8)
        current.should be_current
        current.should be_empty
      end

    end

    it "should generate vaccine row headers" do
      presenter.should have(1).vaccines
      presenter.vaccines.first.tap do |v|
        v.name.should eq(vaccine.name)
      end
    end

    it "should generate vaccinations info" do
      vaccine = presenter.vaccines.first
      vaccinations = presenter.vaccinations_for(vaccine)
      vaccinations.should have(3).items

      vaccinations.tap do |v0,v1,v2|
        v0.name.should eq(doses[0].name)
        v0.status.should eq("planned")

        v1.name.should eq(doses[1].name)
        v1.status.should eq("planned")

        v2.name.should eq(doses[2].name)
        v2.status.should eq("planned")
      end
    end

  end

end