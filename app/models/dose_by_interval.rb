class DoseByInterval < Dose

  enum_attr :interval_unit, %w(^years months)

end