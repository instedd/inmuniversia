class DashboardController < AuthenticatedController

  def index
    @children = current_subscriber.children
    render 'dashboard'
  end

end