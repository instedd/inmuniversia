RSpec::Matchers.define :be_during do |year, month, day|
  match do |actual|
    (year.nil?  || actual.year == year) &&\
    (month.nil? || actual.month == month) &&\
    (day.nil?   || actual.day == day)
  end

  description do 
    "be during " + [year && "year #{year}", month && "month #{month}", day && "day #{day}"].compact.join(", ")
  end
end