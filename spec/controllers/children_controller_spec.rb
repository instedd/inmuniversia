require 'spec_helper'

describe ChildrenController do

  let(:subscriber) { create(:subscriber) }
  before(:each) {sign_in subscriber}

  context "on create" do

    it "should create a child" do
      expect {
        xhr :post, :create, child: attributes_for(:child)
      }.to change(subscriber.children, :count).by(1)
      response.should be_successful
    end

    it "should not create a child if invalid params" do
      expect {
        xhr :post, :create, child: attributes_for(:child, name: "")
      }.to change(Child, :count).by(0)
      response.should be_successful
    end

  end

end