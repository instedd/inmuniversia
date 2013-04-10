class Child < ActiveRecord::Base
  belongs_to :parent, class_name: 'Subscriber'

  has_many :vaccinations

  attr_accessible :date_of_birth, :gender, :name, :parent_id

  def assume_vaccinated_until_today!(vaccines=nil)
    vaccines ||= Vaccine.includes(:doses)
    vaccines.each do |vaccine|
      vaccine.doses.each do |dose|
        if dose.in_date_for?(self)
          date = dose.date_for(self)
          self.vaccinations.build(dose: dose, date: date)
        else
          break
        end
      end
    end

    save!
  end
end
