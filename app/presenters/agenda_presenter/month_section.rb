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
    I18n.l(Date.new(@year, @month), format: :month_year).capitalize
  end

end
