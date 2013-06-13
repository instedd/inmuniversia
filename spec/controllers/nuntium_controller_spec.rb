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

describe NuntiumController do
  sms_number = "12345678"

  context "authenticated" do
    before(:each) {hhtp_authorization @request, Settings.nuntium.incoming_username, Settings.nuntium.incoming_password}

    it "receives at and replies nothing" do

      post :receive_at, 'body' => 'foo'

      response.should be_success
      response.body.should be_blank
    end


    ["alta", "ALTA", "alta2"].each do |message|
      it "receives at #{message} msg and creates channel" do
        expect {
          post :receive_at, :body => message, :from => sms_number
        }.to change(Channel::Sms, :count).by(1)

        Channel::Sms.last.address.should eq(sms_number)

        response.should be_success
        response.body.should eq('Bienvenido a Inmuniversia')
        response.content_type.should eq('text/plain')
      end
    end
  end

  it "performs basic http auth" do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("wrong:wrong")

    post :receive_at, 'body' => 'foo'

    response.code.should eq('401')
  end
end