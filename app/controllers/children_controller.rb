class ChildrenController < AuthenticatedController

  respond_to :js

  def create
    @child = current_subscriber.children.new(params[:child])

    if @child.save
      # TODO: Move to on create callbacks
      @child.create_vaccinations!
      @child.subscribe!
    end
  end

  protected

  def load_children
    @children = current_subscriber.children
  end

  def load_child
    @child = current_subscriber.children.find(params[:id])
  end

end
