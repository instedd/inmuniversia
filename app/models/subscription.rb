class Subscription < ActiveRecord::Base
  belongs_to :vaccine, class_name: '::Vaccine'
  belongs_to :child

  attr_accessible :status, :vaccine, :child

  enum_attr :status, %w(^active disabled)

  validates :vaccine_id, presence: true, uniqueness: {scope: :child_id}
end
