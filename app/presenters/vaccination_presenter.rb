class VaccinationPresenter
  delegate :id, :status, to: :@vaccination

  def date
    Date.new(@vaccination.date.year, @vaccination.date.month, @vaccination.date.day)
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

  def self.present(vaccinations)
    vaccinations.map{|v| self.new(v)}
  end

  def initialize(vaccination)
    @vaccination = vaccination
  end

end