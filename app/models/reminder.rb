class Reminder < ActiveRecord::Base
  extend Enumerize

  belongs_to :vaccination
  attr_accessible :sent_at, :status, :type

  enumerize :status, in: %w(pending sent), default: :pending

  scope :pending, where(status: :pending)

  def send_at
    subclass_responsibility
  end

end
