module Refinery
  module Vaccines
    class Vaccine < Refinery::Core::BaseModel
      self.table_name = 'refinery_vaccines'

      attr_accessible :name, :vaccine_type, :description, :photo_id, :position

      acts_as_indexed :fields => [:name, :vaccine_type, :description]

      validates :name, :presence => true, :uniqueness => true

      belongs_to :photo, :class_name => '::Refinery::Image'
    end
  end
end
Vaccine