class Subscription < ActiveRecord::Base
  belongs_to :vaccine
  belongs_to :child
  attr_accessible :status
end
