RSpec::Matchers.define :be_sent_at do |year, month, day|
  match do |reminder|
    actual = reminder.sent_at
    reminder.status == "sent" &&\
    (year.nil?  || actual.year == year) &&\
    (month.nil? || actual.month == month) &&\
    (day.nil?   || actual.day == day)
  end
end