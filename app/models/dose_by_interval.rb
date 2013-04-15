class DoseByInterval < Dose

  extend Enumerize

  enumerize :interval_unit, in: %w(years months weeks days), predicates: {prefix: true}, default: :years

  def interval
    return nil unless interval_value
    interval_value.send(interval_unit)
  end

  def date_for(child)
    previous_vaccination = previous_dose.vaccination_for(child)
    previous_vaccination && previous_vaccination.date + interval
  end

  def previous_dose
    self.higher_item
  end

end