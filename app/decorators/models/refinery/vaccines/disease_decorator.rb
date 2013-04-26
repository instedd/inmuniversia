Refinery::Vaccines::Disease.class_eval do
  has_and_belongs_to_many :vaccines
  attr_accessible :vaccine_ids

  scope :published, where(published: true)
end