module Refinery
  module Vaccines
    class Disease < Refinery::Core::BaseModel

      has_and_belongs_to_many :vaccines

      attr_accessible :name, :description, :photo_id, :position

      acts_as_indexed :fields => [:name, :description]

      validates :name, :presence => true, :uniqueness => true

      belongs_to :photo, :class_name => '::Refinery::Image'
    end
  end
end
Disease