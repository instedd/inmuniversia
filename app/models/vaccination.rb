class Vaccination < ActiveRecord::Base
  attr_accessible :child_id, :date, :dose_id, :vaccine_id
end
