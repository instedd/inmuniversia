require 'spec_helper'

describe CalendarForm do

  let(:child)     { create(:child, :with_setup, date_of_birth: Date.new(2012,6,15)) }
  let(:presenter) { CalendarPresenter.new(child) }  
  let(:form)      { presenter.form }  

  before(:each) { Timecop.freeze(Time.utc(2013,6,10,12,0,0)) }

  context "with child attributes" do

    it "should return attributes" do
      form.child_name.should eq(child.name)
      form.child_date_of_birth.should eq(child.date_of_birth)
    end

    it "should set attributes" do
      form.child_name = "Edited name"
      child.name.should eq("Edited name")

      form.child_date_of_birth = Date.new(2010)
      child.date_of_birth.should eq(Date.new(2010))
    end

    it "should save new attributes" do
      form.child_name = "Edited name"
      form.child_date_of_birth = Date.new(2010)
      
      form.save.should be_true

      child.reload.name.should eq("Edited name")
      child.reload.date_of_birth.should eq(Date.new(2010))
    end

  end

  context "with subscriptions" do

    let!(:vaccine) { create(:vaccine, :with_doses) }
    let(:subscription) { child.subscriptions.first }

    it "should update subscriptions statuses" do
      subscription.reload.status.should eq("active")
      form.update_attributes(vaccines_attributes: { 
        "0" => { subscription_id: subscription.id, id: subscription.id, enabled: "0"}
      })

      subscription.reload.status.should eq("disabled")
    end

  end

end