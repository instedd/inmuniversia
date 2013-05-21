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