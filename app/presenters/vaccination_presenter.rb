class VaccinationPresenter < Presenter
  delegate :id, :status, :status_text, to: :@vaccination
  display :id, :date, :date_string, :date_short, :child_name, :vaccine_name, :name, :status, :status_icon, :status_text

  def date
    Date.new(@vaccination.date.year, @vaccination.date.month, @vaccination.date.day)
  end

  def date_string
    I18n.l(date, format: :long)
  end

  def date_short
    I18n.l(date, format: :default)
  end

  def child_name
    @vaccination.child.name
  end

  def vaccine_name
    @vaccination.vaccine.name
  end

  def name
    @vaccination.dose.name
  end

  def full_description
    "#{name} de #{vaccine_name} a #{child_name}"
  end

  def status_icon
    "st-#{status}"
  end

  def initialize(vaccination)
    @vaccination = vaccination
  end

end