class Object
  def not_nil?
    !nil?
  end

  def not_blank?
    !blank?
  end

  def is_an? object
    is_a? object
  end

  def subclass_responsibility
    raise 'Subclasses must redefine this method'
  end
end
