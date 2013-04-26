# coding: utf-8

class AgendaPresenter::YearSection < AgendaPresenter::Section
  attr_accessor :year

  def initialize(opts={})
    @year = opts[:year]
    super
  end

  def title
    if @year == @today.year
      "Este año"
    else
      "En #{pluralize(@year - @today.year, 'año', 'años')}"
    end
  end

  def date
    I18n.l(Date.new(@year), format: :year)
  end

end
