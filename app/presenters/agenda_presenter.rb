# encoding UTF-8

class AgendaPresenter

  attr_accessor :sections

  def initialize(subscriber)
    @today = Date.today
    @subscriber = subscriber
    @sections = load_sections
  end


  protected


  def load_sections
    @current_section = initialize_current_section
    @past_section =    build_past_section

    @monthly_sections = Hash.new do |h, key|
      year, month = key
      h[key] = MonthSection.new(month: month, year: year, today: @today)
    end

    @yearly_sections = Hash.new do |h, key|
      year = key
      h[key] = YearSection.new(year: year, today: @today)
    end

    @subscriber.vaccinations.future.to_a.sort_by(&:planned_date).each do |vaccination|
      section_for(vaccination).vaccinations << VaccinationPresenter.new(vaccination)
    end

    sections = [@past_section, @current_section] + @monthly_sections.sort.map{|k,v| v} + @yearly_sections.sort.map{|k,v| v}
    sections.reject(&:empty?)
  end

  def build_past_section
    Section.new title: "Vencidas",
      vaccinations: VaccinationPresenter.present(@subscriber.vaccinations.past.to_a.sort_by(&:planned_date))
  end

  def initialize_current_section
    Section.new title: "Actuales"
  end

  def section_for(vaccination)
    date = vaccination.planned_date
    diff = (date - @today).days

    if date < @today.end_of_month
      @current_section
    elsif diff < 6.months
      @monthly_sections[[date.year, date.month]]
    else 
      @yearly_sections[date.year]
    end
  end

end