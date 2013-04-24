class Child < ActiveRecord::Base

  extend Enumerize

  belongs_to :parent, class_name: 'Subscriber'

  has_many :vaccinations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  attr_accessible :date_of_birth, :gender, :name, :parent_id

  enumerize :gender, in: %w(male female), predicates: true, default: nil

  validates :name, presence: true, uniqueness: {case_sensitive: false, scope: :parent_id, message: "%{value} ya fue registrado en Inmuniversia"}
  validates :date_of_birth, presence: true

  def subscriber
    parent
  end

  def setup!(vaccines=nil)
    subscribe!(vaccines)
    create_vaccinations!(vaccines)
  end

  def create_vaccinations!(vaccines=nil)
    vaccines ||= default_vaccines
    today = Date.today

    vaccines.each do |vaccine|
      vaccine.doses.each do |dose|
        date = dose.date_for(self)
        status = date < today ? :past : :planned
        vaccinations.build(dose: dose, status: status)
      end
    end

    save!
  end

  def subscribe!(vaccines=nil)
    vaccines ||= default_vaccines
    vaccines.each do |vaccine|
      self.subscriptions.build(vaccine: vaccine) unless self.subscriptions.any? {|s| s.vaccine == vaccine}
    end
    save!
  end

  protected

  def default_vaccines
    ::Vaccine.defaults.includes(:doses)
  end

end
