class Child < ActiveRecord::Base
  belongs_to :parent, class_name: 'Subscriber'

  has_many :vaccinations
  has_many :subscriptions

  attr_accessible :date_of_birth, :gender, :name, :parent_id

  def subscriber
    parent
  end

  def create_vaccinations!(vaccines=nil)
    vaccines ||= default_vaccines
    today = Date.today

    vaccines.each do |vaccine|
      vaccine.doses.each do |dose|
        date = dose.date_for(self)
        status = date < today ? :past : :planned
        vaccinations.build(dose: dose, planned_date: date, status: status)
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


  # def pending_doses_for(vaccine)
  #   last_vaccination = last_vaccination_for(vaccine)
  #   return vaccine.doses if last_vaccination.nil?
  #   last_vaccination.dose.lower_items
  # end

  # def last_vaccination_for(vaccine)
  #   # TODO: Define proper order for vaccinations
  #   self.vaccinations.where(vaccine_id: vaccine.id).last
  # end

  protected

  def default_vaccines
    ::Vaccine.defaults.includes(:doses)
  end

end
