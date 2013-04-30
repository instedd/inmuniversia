class DashboardController < AuthenticatedController

  layout 'sidebar'
  
  def index
    @children = current_subscriber.children
    @active_tab = current_subscriber.preferences.fetch('dashboard.active_tab', 'calendars')
    render 'dashboard'
  end

end