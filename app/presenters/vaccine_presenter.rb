class VaccinePresenter
  delegate :id, :name, :diseases, to: :@vaccine

  def self.present(vaccines)
    vaccines.map{|v| self.new(v)}
  end

  def initialize(vaccine)
    @vaccine = vaccine
  end

  def diseases_list
    diseases.map(&:name).join(", ")
  end
end