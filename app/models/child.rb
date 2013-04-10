class Child < ActiveRecord::Base
  belongs_to :parent, class_name: 'Subscriber'

  attr_accessible :date_of_birth, :gender, :name, :parent_id

  alias_method 'subscriber',  'parent'
  alias_method 'subscriber=', 'parent='
end
