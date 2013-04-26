module Concerns::Timespanize

  def self.extended(base)
    base.send(:extend, Enumerize)
  end

  def timespanize(field_name, opts={})
    value_field =   opts.fetch(:value, "#{field_name}_value")
    unit_field =    opts.fetch(:unit, "#{field_name}_unit")
    unit_values =   opts.fetch(:unit_values, [:year, :month, :week])
    unit_default =  opts.fetch(:unit_default, :year)
    end_method =    opts.fetch(:end, "#{field_name}_end")
    desc_method =   opts.fetch(:description, "#{field_name}_description")

    enumerize unit_field, in: unit_values, default: unit_default

    define_method(field_name) do
      value = send(value_field)
      unit = send(unit_field)
      value && unit && value.send(unit)
    end

    define_method(end_method) do
      unit = send(unit_field)
      send(field_name) + 1.send(unit)
    end

    define_method(desc_method) do
      value = send(field_name)
      value.nil? ? "" : value.inspect
    end
  end

end