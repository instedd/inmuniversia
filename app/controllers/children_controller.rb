class ChildrenController < AuthenticatedController

  respond_to :js

  def create
    @child = current_subscriber.children.new(params[:child])
    @active_tab = current_subscriber.preferences.fetch('dashboard.active_tab', 'calendars')
    @child.setup! if @child.save
  end

  def destroy
    @child = Child.find(params[:id])
    if @child.destroy
      redirect_to root_path
    else
      render :js => "alert('Hubo un error desuscribiendo a #{@child.name}');"
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
