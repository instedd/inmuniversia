require 'spec_helper'

describe Channel::Sms do

  context "verification code" do

    let(:channel) { create(:sms_channel, address: "12345") }

    it "should be sent via nuntium" do
      Nuntium.any_instance.should_receive(:send_ao) do |msg|
        msg[:to].should   eq("sms://12345")
        msg[:from].should eq("sms://999")
        msg[:body].should include(channel.verification_code.to_s)
        {id: 1, guid: 1, token: 1}
      end

      channel.send_verification_code
    end

  end
  
end