module DashboardHelper

  def render_calendar(child, opts={})
    render 'dashboard/calendar', calendar: CalendarPresenter.new(child), new: opts[:new]
  end

  def render_agenda(subscriber)
    render 'dashboard/agenda', agenda: AgendaPresenter.new(subscriber)
  end

end