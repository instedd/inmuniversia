class Dose < ActiveRecord::Base
  
  belongs_to :vaccine

  attr_accessible :age_unit, :age_value, :interval_unit, :interval_value, :name, :order, :type

end
