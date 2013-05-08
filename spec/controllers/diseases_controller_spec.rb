require 'spec_helper'

describe DiseasesController do

  context "index" do

    let!(:published_diseases)   { create_list(:disease, 3, published: true) }
    let!(:unpublished_diseases) { create_list(:disease, 2, published: false) }

    it "should only list published diseases" do
      get :index
      response.should be_success
      assigns(:diseases).should match_array(published_diseases)
    end

    it "should list all diseases if user is logged in" do
      sign_in create(:refinery_user)
      get :index
      response.should be_success
      assigns(:diseases).should match_array(published_diseases + unpublished_diseases)
    end

  end

  context "show" do

    let!(:disease) {create(:disease, published: true)}

    it "should render disease page" do
      get :show, id: disease.id
      response.should be_success
    end

  end

end