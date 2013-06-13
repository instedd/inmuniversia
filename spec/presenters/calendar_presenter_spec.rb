# Copyright (C) 2013, InSTEDD
#
# This file is part of Inmuniversia.
#
# Inmuniversia is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Inmuniversia is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Inmuniversia.  If not, see <http://www.gnu.org/licenses/>.

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


  context "with multiple vaccines" do

    context "on disabled notifications" do

      let!(:vaccine_subscribed)     { create(:vaccine, :with_doses) }
      
      let!(:vaccine_not_subscribed) do 
        create(:vaccine, :with_doses, first_dose_at: 5).tap do |v| 
          child.subscriptions.where(vaccine_id: v.id).first.update_column(:status, 'disabled') && child.reload
        end
      end

      it "should not return vaccines with subscription disabled" do
        presenter.should have(1).active_vaccines
      end

      it "should not render timespans for vaccines with subscription disabled" do
        presenter.should have(3).timespans
      end

    end

  end

end