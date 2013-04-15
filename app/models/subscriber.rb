class Subscriber < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :children, inverse_of: :parent, foreign_key: :parent_id

  def time_offset
    '-3'
  end

  def full_name
    email
  end
end
