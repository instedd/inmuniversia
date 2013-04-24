require 'spec_helper'

describe VaccinesController do

  let!(:published_vaccines)   { create_list(:vaccine, 3, published: true) }
  let!(:unpublished_vaccines) { create_list(:vaccine, 2, published: false) }

  it "should only list published vaccines" do
    get :index
    response.should be_success
    assigns(:vaccines).should match_array(published_vaccines)
  end

  it "should list all vaccines if user is logged in" do
    sign_in create(:refinery_user)
    get :index
    response.should be_success
    assigns(:vaccines).should match_array(published_vaccines + unpublished_vaccines)
  end

end