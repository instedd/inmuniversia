class DoseByAge < Dose

  enum_attr :age_unit, %w(^years months)

  def age
    return nil unless age_value
    age_value.send(age_unit)
  end

  def date_for(child)
    child.date_of_birth + self.age
  end

end