class DashboardController < AuthenticatedController

  layout 'sidebar'
  
  def index
    @children = current_subscriber.children
    render 'dashboard'
  end

end