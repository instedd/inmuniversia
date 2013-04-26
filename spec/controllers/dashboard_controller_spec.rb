require 'spec_helper'

describe DashboardController do

  let(:subscriber) { create(:subscriber) }
  before(:each) {sign_in subscriber}

  it "should load successfully" do
    create(:vaccine, :with_doses)
    create(:child, :with_setup, parent: subscriber)

    get :index
    
    response.should be_successful
    assigns(:children).should have(1).item
  end

end