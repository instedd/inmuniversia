class ChildrenController < AuthenticatedController

  respond_to :js

  def create
    @child = current_subscriber.children.new(params[:child])
    @active_tab = current_subscriber.preferences.fetch('dashboard.active_tab', 'calendars')
    @child.setup! if @child.save
  end

  protected

  def load_children
    @children = current_subscriber.children
  end

  def load_child
    @child = current_subscriber.children.find(params[:id])
  end

end
