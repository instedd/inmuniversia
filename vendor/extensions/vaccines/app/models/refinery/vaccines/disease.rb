module Refinery
  module Vaccines
    class Disease < Refinery::Core::BaseModel

      attr_accessible :name, :incidence_info, :geographical_distribution, :high_risk_groups, :rate_info, :published, :position

      acts_as_indexed :fields => [:name, :incidence_info, :geographical_distribution, :high_risk_groups, :rate_info]

      validates :name, :presence => true, :uniqueness => true
    end
  end
end
Disease