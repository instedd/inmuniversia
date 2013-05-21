require 'spec_helper'

describe CalendarsController do

  let(:subscriber) { create(:subscriber) }
  before(:each)    {sign_in subscriber}

  context "on update" do

    let!(:child) { create(:child, :with_setup, parent: subscriber, name: "John") }

    it "should update a calendar with new child attributes" do
      xhr :put, :update, id: child.id, calendar: { child_name: 'Edited name'}
      response.should be_successful
      child.reload.name.should eq("Edited name")
    end

    it "should not update a calendar with invalid child attributes" do
      xhr :put, :update, id: child.id, calendar: { child_name: ''}
      response.should be_successful
      child.reload.name.should eq("John")
    end

  end

end