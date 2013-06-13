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