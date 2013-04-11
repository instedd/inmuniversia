require 'spec_helper'

describe Subscription do
  
  it "cannot create more than one subscription for the same child and vaccine" do
    child, vaccine = create(:child), create(:vaccine)
    create(:subscription, child: child, vaccine: vaccine)
    
    expect {
      duplicated_subscription = build(:subscription, child: child, vaccine: vaccine)
      duplicated_subscription.save.should be_false
    }.to change(Subscription, :count).by(0)
  end

end
