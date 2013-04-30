module DashboardHelper

  def render_calendar(child)
    render 'dashboard/calendar', calendar: CalendarPresenter.new(child)
  end

  def render_agenda(subscriber)
    render 'dashboard/agenda', agenda: AgendaPresenter.new(subscriber)
  end  

end