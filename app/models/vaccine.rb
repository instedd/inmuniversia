Vaccine = Refinery::Vaccines::Vaccine

class Vaccine
  # Define additional methods for vaccine here
  has_and_belongs_to_many :diseases
  attr_accessible :disease_ids
end