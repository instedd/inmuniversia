class Hash
  def get_bool(key)
    value = self[key]
    case value
    when String
      !value.blank? && %W(true True t 1).include?(value.to_s)
    when TrueClass, FalseClass
      value
    when Fixnum
      value != 0
    when NilClass
      false
    else
      true
    end
  end
end