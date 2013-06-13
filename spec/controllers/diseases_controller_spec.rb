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