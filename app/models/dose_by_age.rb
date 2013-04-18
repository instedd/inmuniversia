class DoseByAge < Dose

  extend Concerns::Timespanize
  
  timespanize :age

  def date_for(child)
    child.date_of_birth + self.age
  end

  def span
    1.send(age_unit)
  end

end