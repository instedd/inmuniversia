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