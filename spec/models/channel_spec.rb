require 'spec_helper'

describe Channel do

  context "factories" do

    it "should create sms channel from factory" do
      create(:sms_channel).should be_valid
    end

    it "should create email channel from factory" do
      create(:email_channel).should be_valid
    end

  end

end
