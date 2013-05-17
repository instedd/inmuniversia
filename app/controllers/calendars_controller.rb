class CalendarsController < AuthenticatedController

  respond_to :js

  before_filter :load_calendar

  def update
    @form.update_attributes(params[:calendar])
  end

  protected

  def load_calendar
    @child = current_subscriber.children.find(params[:id])
    @calendar = CalendarPresenter.new(@child)
    @form = @calendar.form
  end

end
