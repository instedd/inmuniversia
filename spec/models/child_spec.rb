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
