module Refinery
  module Vaccines
    class Disease < Refinery::Core::BaseModel

      attr_accessible :name, :summary, :transmission, :diagnosis, :treatment, :statistics, :published, :position

      acts_as_indexed :fields => [:name, :summary, :transmission, :diagnosis, :treatment, :statistics]

      validates :name, :presence => true, :uniqueness => true
    end
  end
end
