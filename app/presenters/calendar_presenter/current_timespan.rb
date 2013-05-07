class CalendarPresenter::CurrentTimespan

  attr_accessor :year, :month

  def initialize
    @today = Date.today
    @year = @today.year
    @month = @today.month
  end

  def <=>(other)
    [self.year, self.month] <=> [other.year, other.month]
  end

  def current?
    true
  end

  def empty?
    true
  end

  def age
    nil
  end

end