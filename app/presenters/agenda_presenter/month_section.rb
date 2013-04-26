class AgendaPresenter::MonthSection < AgendaPresenter::Section
  attr_accessor :month, :year

  def initialize(opts={})
    @month = opts[:month]
    @year = opts[:year]
    super
  end

  def title
    months = (@month - @today.month) % 12
    "En #{pluralize(months, 'mes', 'meses')}"
  end

  def date
    Date.new(@year, @month).strftime("%B %Y")
  end
end
