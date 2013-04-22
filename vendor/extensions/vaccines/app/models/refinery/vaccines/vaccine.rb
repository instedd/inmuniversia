module Refinery
  module Vaccines
    class Vaccine < Refinery::Core::BaseModel
      self.table_name = 'refinery_vaccines'

      attr_accessible :name, :general_info, :commercial_name, :doses_info, :recommendations, :side_effects, :more_info, :published, :position, :in_calendar

      acts_as_indexed :fields => [:name, :general_info, :commercial_name, :doses_info, :recommendations, :side_effects, :more_info]

      validates :name, :presence => true, :uniqueness => true
    end
  end
end
Vaccine