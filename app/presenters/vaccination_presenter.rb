class VaccinationPresenter
  delegate :id, :date, :status, to: :@vaccination

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