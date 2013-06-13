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

    it "should create vaccinations and subscriptions" do
      vaccine = create(:vaccine, :with_doses)
      xhr :post, :create, child: attributes_for(:child)
      
      child = subscriber.reload.children.first
      child.should have(1).subscription
      child.should have(3).vaccinations
    end

    it "should not create a child if invalid params" do
      expect {
        xhr :post, :create, child: attributes_for(:child, name: "")
      }.to change(Child, :count).by(0)
      response.should be_successful
    end

  end

end