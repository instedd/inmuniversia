class DoseByInterval < Dose

  enum_attr :interval_unit, %w(^years months weeks days)

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