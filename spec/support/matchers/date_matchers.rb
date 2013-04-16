RSpec::Matchers.define :be_during do |year, month, day|
  match do |actual|
    actual &&\
    (year.nil?  || actual.year == year) &&\
    (month.nil? || actual.month == month) &&\
    (day.nil?   || actual.day == day)
  end

  def build_description(year, month, day)
    "be during " + [year && "year #{year}", month && "month #{month}", day && "day #{day}"].compact.join(", ")
  end

  description do 
    build_description(year, month, day)
  end

  failure_message_for_should do |actual|
    "expected #{actual || actual.inspect} to #{build_description(year, month, day)}"
  end

  failure_message_for_should_not do |actual|
    "expected #{actual || actual.inspect} not to #{build_description(year, month, day)}"
  end

end