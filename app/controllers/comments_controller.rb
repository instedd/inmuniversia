class CommentsController < ApplicationController
  def create
    @comment_hash = params[:comment]
    @obj = @comment_hash[:commentable_type].constantize.find(@comment_hash[:commentable_id])
    # Not implemented: check to see whether the user has permission to create a comment on this object
    @comment = Comment.build_from(@obj, current_subscriber, @comment_hash[:body])
    if @comment.save
      if @comment_hash[:parent_id] != ""
        @comment.move_to_child_of(Comment.find(@comment_hash[:parent_id]))
      end
      render :partial => "comments/comment", :locals => { :comment => @comment }, :layout => false, :status => :created
    else
      #completar mejor
      render :js => "alert('Hubo un error salvando el comentario');"
    end
  end

  def destroy
    #chequear que haya un usuario de refinery logueado para poder borrar
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