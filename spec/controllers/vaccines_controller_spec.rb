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

describe VaccinesController do

  context "index" do

    let!(:published_vaccines)   { create_list(:vaccine, 3, published: true) }
    let!(:unpublished_vaccines) { create_list(:vaccine, 2, published: false) }

    it "should only list published vaccines" do
      get :index
      response.should be_success
      assigns(:vaccines).should match_array(published_vaccines)
    end

    it "should list all vaccines if user is logged in" do
      sign_in create(:refinery_user)
      get :index
      response.should be_success
      assigns(:vaccines).should match_array(published_vaccines + unpublished_vaccines)
    end

  end

  context "show" do

    let!(:vaccine) {create(:vaccine, published: true)}
    let!(:subscriber) {create(:subscriber)}
    let!(:comment_list) {create_list(:comment, 3, subscriber: subscriber, commentable: vaccine)}

    it "should render vaccine page" do
      get :show, id: vaccine.id
      response.should be_success
    end

    it "should return the comments in the right order" do
      child1 = Comment.build_from(vaccine, subscriber, "test")
      child2 = Comment.build_from(vaccine, subscriber, "test2")
      child3 = Comment.build_from(vaccine, subscriber, "test3")

      child1.save
      child2.save
      child3.save

      child1.move_to_child_of(comment_list[1])
      child2.move_to_child_of(comment_list[0])
      child3.move_to_child_of(comment_list[1])

      reference_hash = [{"father" => comment_list[0], "children" => [child2]}, {"father" => comment_list[1], "children" => [child1, child3]}, {"father" => comment_list[2], "children" => []}]

      get :show, id: vaccine.id

      assigns(:comments).should match_array(reference_hash)
    end

  end

end