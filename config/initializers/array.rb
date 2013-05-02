class Array

  def ensure_includes(obj)
    raise "#{obj} should be included in #{self}" unless self.include?(obj)
    return obj
  end

end