module ChildrenHelper

  def render_calendar(child)
    render 'children/calendar', calendar: CalendarPresenter.new(child)
  end

  def render_new_child_form(child=nil)
    child ||= Child.new
    render 'children/form', child: child
  end

end
