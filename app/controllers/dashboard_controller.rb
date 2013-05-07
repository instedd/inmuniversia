class DashboardController < AuthenticatedController

  before_filter :load_vaccination_options

  layout 'sidebar'
  set_body_class 'dashboard'
  
  def index
    @children = current_subscriber.children
    @active_tab = current_subscriber.preferences.fetch('dashboard.active_tab', 'calendars')
    render 'dashboard'
  end

  protected

  def load_vaccination_options
    gon.vaccinationOptions = Vaccination.status.options.map do |label, value|
      {label: label, value: value, status_icon: "st-#{value}"}
    end
  end

end