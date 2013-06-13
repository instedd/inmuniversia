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

class VaccinesController < ApplicationController

  before_filter :load_vaccines

  layout 'sidebar', only: :show
  set_body_class 'public-content'

  def index
  end

  def show
    @vaccine = @vaccines.find(params[:id])
    @new_comment = Comment.build_from(@vaccine, current_subscriber, "")
    @comments = sorted_comments
  end

  protected

  def load_vaccines
    @vaccines = if user_signed_in?
      Vaccine.scoped
    else
      Vaccine.published
    end
  end

  def sorted_comments
    if !@vaccine.comment_threads.empty?
      comment_groups = @vaccine.comment_threads.group_by {|c| c.parent_id}
      comments = []
      comment_groups[nil].each do |comment|
        comment_hash ={}
        comment_hash[:father] = comment
        comment_hash[:children] = []
        unless comment_groups[comment.id].nil?
          comment_hash[:children] = comment_groups[comment.id]
        end
        comments << comment_hash
      end
      comments
    end
  end
end