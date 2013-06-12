require File.expand_path("../../../lib/extras/subscriber_and_child_importer", __FILE__)
require 'spec_helper'

describe SubscriberAndChildImporter do

  def import_csv(file_name)
    count = SubscriberAndChildImporter.new.import! File.join('spec', 'csv', "#{file_name}.csv")
    count
  end

  before :each do
    Subscriber.destroy_all
  end

  it "should import the right number of subscribers from a CSV file" do
    import_csv 'datos'

    Subscriber.count.should eq(4)
  end

  it "should create subscribers with first name from a CSV file" do
    import_csv 'datos'

    Subscriber.where(:first_name => "Jorge").count.should eq(1)
    Subscriber.where(:first_name => "Maria").count.should eq(1)
    Subscriber.where(:first_name => "Rolando").count.should eq(1)
    Subscriber.where(:first_name => "Josefa").count.should eq(1)
  end

  it "should assign the phone numbers to subscribers from a CSV file" do
    import_csv 'datos'

    Channel::Sms.where(:address => "1558983390").count.should eq(1)
    Channel::Sms.where(:address => "1512346523").count.should eq(1)
    Channel::Sms.where(:address => "54320987").count.should eq(1)
    Channel::Sms.where(:address => "1558983390").count.should eq(1)
  end

  it "should create a child with the proper data for each of the records on the CSV" do
    import_csv 'datos1'

    child1 = Subscriber.first.children[0]
    child2 = Subscriber.last.children[0]

    child1.name.should eq("Ramona")
    child2.name.should eq("Richard")

    child1.gender.should eq("female")
    child2.gender.should eq("male")

    child1.date_of_birth.should eq(Date.new(2012,01,04))
    child2.date_of_birth.should eq(Date.new(2012,8,25))

  end

  it "should subscribe the children to the current vaccines for each of the records on the CSV" do
    Vaccine.setup "Sabin (OPV)",
      {name: "Primera dosis", age_value: 2,  age_unit: "month"},
      {name: "Segunda dosis", age_value: 4,  age_unit: "month"},
      {name: "Tercera dosis", age_value: 6,  age_unit: "month"},
      {name: "Cuarta dosis", age_value: 18,  age_unit: "month"},
      {name: "Refuerzo", age_value: 6,  age_unit: "year"}

    Vaccine.setup "Cuadruple DTP-Hib",
      {name: "Primer refuerzo", age_value: 18, age_unit: "month"}

    Vaccine.setup "Hepatitis A",
      {name: "Unica dosis", age_value: 12, age_unit: "month"}

    import_csv 'datos1'

    child1 = Subscriber.first.children[0]
    child2 = Subscriber.last.children[0]

    child1.vaccinations.count.should eq(6)
    child2.vaccinations.count.should eq(6)

    child1.subscriptions.count.should eq(3)
    child2.subscriptions.count.should eq(3)
  end

end