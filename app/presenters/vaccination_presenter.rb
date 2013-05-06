class VaccinationPresenter
  delegate :id, :status, to: :@vaccination

  def date
    Date.new(@vaccination.date.year, @vaccination.date.month, @vaccination.date.day)
  end

  def date_string
    I18n.l(date, format: :long)
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

  def to_hash
    {date: date, date_string: date_string, child_name: child_name, vaccine_name: vaccine_name, name: name, status: status, id: id}
  end

  # TODO: Move this method to a parent Presenter class as necessary
  def to_data_hash
    Hash[to_hash.map do |key,value|
      ["data-#{key}", value]
    end]
  end

  def self.present(vaccinations)
    vaccinations.map{|v| self.new(v)}
  end

  def initialize(vaccination)
    @vaccination = vaccination
  end

end