Vaccine = Refinery::Vaccines::Vaccine

class Vaccine
  has_and_belongs_to_many :diseases
  has_many :doses, order: :number

  attr_accessible :disease_ids, :name

  def next_dose_for(child)
    doses_given_ids = child.vaccinations_for(self).map(&:dose_id)
    doses.where("id NOT IN (?)", doses_given_ids).first
  end
end