require 'spec_helper'

describe Notifier do

  let(:current_time) { Time.utc(2013,1,1,12,0,0) }

  before(:each) { Timecop.freeze(current_time) }
  after(:each)  { Timecop.return }

  let(:notifier) { Notifier.new }


  context "sending reminders" do

    let!(:vaccine)    { create(:vaccine, :with_doses) }
    let!(:subscriber) { create(:subscriber, next_message_at: Date.new(2013)) }
    let!(:child)      { create(:child, :with_vaccinations, :with_subscriptions, parent: subscriber, date_of_birth: Date.new(2012, 6, 10)) }

    def send_reminders(*reminders, subscriber)
      notifier.send_reminders(reminders, subscriber)
      run_jobs
    end

    context "via email" do

      let(:channel) { subscriber.email_channels.first }

      it "should deliver a single reminder of upcoming dose via email" do
        reminder = child.vaccinations.first.reminders.first
        reminder.update_attributes!(status: 'sending')
        reminder.should be_a(ReminderUpcomingDose)

        send_reminders(reminder, subscriber)

        deliveries.should have(1).email
        last_email.subject.should include(reminder.dose.full_name)
        last_email.subject.should include(child.name)
        last_email.to.should eq([channel.address])

        reminder.reload.status.should eq('sent')
        reminder.sent_at.should eq(current_time)
      end


      it "should deliver multiple reminders for different vaccines via email" do
        second_vaccine = create(:vaccine, :with_doses)
        child.create_vaccinations!
        child.subscribe!

        reminders = [
          vaccine.doses.first.vaccinations.first.reminders.first,
          second_vaccine.doses.first.vaccinations.first.reminders.first
        ]
        
        reminders.each do |r| 
          r.should be_a(ReminderUpcomingDose)
          r.status.should eq("pending")
          r.update_attributes!(status: 'sending')
        end

        send_reminders(*reminders, subscriber)

        deliveries.should have(2).email
        
        reminders.each do |r|
          r.reload.status.should eq('sent')
          r.sent_at.should eq(current_time)
        end
      end

    end

  end

end