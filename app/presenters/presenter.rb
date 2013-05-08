class Presenter

  def self.display(*args)
    @fields ||= [] 
    @fields += args
  end

  def self.display_fields
    @fields
  end

  def self.present(models)
    models.map{|v| self.new(v)}
  end

  def to_hash
    Hash[self.class.display_fields.map do |field|
      [field, send(field)]
    end]
  end

  def to_data_hash
    Hash[to_hash.map do |key,value|
      ["data-#{key}", value]
    end]
  end

end