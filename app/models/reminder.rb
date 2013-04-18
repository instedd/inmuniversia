class Reminder < ActiveRecord::Base
  extend Enumerize

  belongs_to :vaccination

  attr_accessible :sent_at, :status, :type

  enumerize :status, in: %w(pending sending sent expired), default: :pending, predicates: true

  acts_as_list scope: :vaccination, column: :number

  scope :pending, where(status: :pending)

  def send_at
    vaccination.planned_date + delta
  end

  def delta
    subclass_responsibility
  end

end
