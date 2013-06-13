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

describe CommentsController do

  context "requests" do

    let!(:vaccine) {create(:vaccine, published: true)}
    let!(:subscriber) {create(:subscriber)}
    let!(:comment) {create(:comment, subscriber: subscriber, commentable: vaccine)}

    it "should load form successfully" do
      sign_in create(:refinery_user)
      post :load_form, commentable_id: vaccine.id, id: comment.id
      response.should be_success
    end

    it "should destroy a comment successfully if there is an user signed in" do
      sign_in create(:refinery_user)
      Comment.count.should equal(1)
      post :destroy, id: comment.id
      response.should be_success
      Comment.count.should equal(0)
    end

    it "should not destroy comment if there is not an user signed in" do
      Comment.count.should equal(1)
      post :destroy, id: comment.id
      Comment.count.should equal(1)
    end

    it "should create a comment with a subscriber signed in" do
      subscriber = create(:subscriber)
      sign_in subscriber
      Comment.count.should eq(1)
      new_comment = Comment.build_from(vaccine, subscriber, "")
      post :create, comment: {commentable_type: new_comment.commentable_type, commentable_id: new_comment.commentable_id, body: "teste"}
      response.should be_success
      Comment.count.should eq(2)
    end

    it "should not create a comment without a subscriber signed in" do
      subscriber = create(:subscriber)
      Comment.count.should eq(1)
      new_comment = Comment.build_from(vaccine, subscriber, "")
      post :create, comment: {commentable_type: new_comment.commentable_type, commentable_id: new_comment.commentable_id, body: "teste"}
      Comment.count.should eq(1)
    end

    it "should create a comment child with a subscriber signed in" do
      subscriber = create(:subscriber)
      sign_in subscriber
      Comment.count.should eq(1)
      new_comment = Comment.build_from(vaccine, subscriber, "")
      post :create, comment: {commentable_type: new_comment.commentable_type, commentable_id: new_comment.commentable_id, body: "teste", parent_id: comment.id}
      response.should be_success
      Comment.count.should eq(2)
      Comment.last.parent_id.should eq(comment.id)
    end

  end
end