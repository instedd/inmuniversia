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

class CommentsController < ApplicationController
  before_filter :authenticate_user!, only: :destroy
  before_filter :authenticate_subscriber!, only: :create
  def create
    @comment_hash = params[:comment]
    @obj = @comment_hash[:commentable_type].constantize.find(@comment_hash[:commentable_id])
    # Not implemented: check to see whether the user has permission to create a comment on this object
    @comment = Comment.build_from(@obj, current_subscriber, @comment_hash[:body])
    if @comment.save
      if @comment_hash[:parent_id] != "" && !@comment_hash[:parent_id].nil?
        @comment.move_to_child_of(Comment.find(@comment_hash[:parent_id]))
      end
      render :partial => "comments/comment", :locals => { :comment => @comment }, :layout => false, :status => :created
    else
      #completar mejor
      render :js => "alert('Hubo un error salvando el comentario');"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render :json => @comment, :status => :ok
    else
      render :js => "alert('Hubo un error borrando el comentario');"
    end
  end

  def load_form
    vaccine = Vaccine.find(params[:commentable_id])
    @comment = Comment.build_from(vaccine, current_subscriber, "")
    @comment.parent_id = params[:id]
    render :partial=>"comments/form", :locals => {:comment => @comment}
  end
end