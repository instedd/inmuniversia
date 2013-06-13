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