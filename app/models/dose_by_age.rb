class DoseByAge < Dose

  extend Enumerize

  enumerize :age_unit, in: %w(years months), predicates: {prefix: true}, default: :years

  def age
    return nil unless age_value
    age_value.send(age_unit)
  end

  def date_for(child)
    child.date_of_birth + self.age
  end

end