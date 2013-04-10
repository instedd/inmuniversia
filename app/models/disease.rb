Disease = Refinery::Vaccines::Disease

class Disease
  # Define additional methods for vaccine here
  has_and_belongs_to_many :vaccines
  attr_accessible :vaccine_ids
end