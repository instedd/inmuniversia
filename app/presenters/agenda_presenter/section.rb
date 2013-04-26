class AgendaPresenter::Section
  include ActionView::Helpers::TextHelper

  attr_accessor :vaccinations

  def initialize(opts={})
    @vaccinations = opts[:vaccinations] || []
    @title = opts[:title]
    @today = opts[:today]
  end

  def empty?
    vaccinations.blank?
  end

  def title
    @title
  end

  def date
    nil
  end

  def vaccination_date_format
    :short
  end

end