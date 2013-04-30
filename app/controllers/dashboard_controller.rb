class DashboardController < AuthenticatedController

  layout 'sidebar'
  set_body_class 'dashboard'
  
  def index
    @children = current_subscriber.children
    @active_tab = current_subscriber.preferences.fetch('dashboard.active_tab', 'calendars')
    render 'dashboard'
  end

end