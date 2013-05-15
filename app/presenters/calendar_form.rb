class CalendarForm

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  delegate :id, :name, :name=, :date_of_birth, :date_of_birth=, to: :child, prefix: true

  def initialize(calendar)
    @calendar = calendar
  end

  def id
    child_id
  end

  def child
    @calendar.child
  end

  def persisted?
    true # Calendar forms are only for updates
  end

  def self.model_name
    ActiveModel::Name.new(CalendarForm, nil, "Calendar")
  end

  def save
    child.save && save_vaccines
  end

  def update_attributes(attributes)
    set_attributes(attributes)
    save
  end

  def vaccines
    @calendar.vaccines
  end

  def vaccines_attributes=(attributes_array)
    @vaccines_attributes= attributes_array
  end

  protected

  def set_attributes(attributes)
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def save_vaccines
    @vaccines_attributes.blank? or @vaccines_attributes.all? do |index, attributes|
      subscription = find_subscription(attributes[:subscription_id])
      status = attributes.get_bool(:enabled) ? 'active' : 'disabled'
      subscription.update_column(:status, status)
    end
  end

  def find_subscription(id)
    @calendar.subscriptions.find{|s| s.id.to_i == id.to_i}
  end

end