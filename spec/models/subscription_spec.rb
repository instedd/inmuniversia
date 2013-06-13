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

  context "date calculation" do

    before(:each) { Timecop.freeze(Time.local(2013,1,1)) }
    after(:each)  { Timecop.return }

    let!(:vaccine)  { create(:vaccine, :with_doses, dose_count: 3) }
    let!(:child)    { create(:child, :with_vaccinations, date_of_birth: Date.new(2011, 5, 10)) }      

    let(:subscription) { create(:subscription, child: child, vaccine: vaccine) }

    it "should return next vaccination planned date" do
      next_vaccination = child.vaccinations[1].tap do |vaccination|
        vaccination.should be_planned
        vaccination.planned_date.should be_during(2013, 5)
      end

      subscription.next_reminder_date.should be_during(2013,5)
    end

  end

  ignore "notifications" do

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
