require 'spec_helper'

describe Notifier do

  before(:each) { Timecop.freeze(Time.utc(2013,1,1,12,0,0)) }
  after(:each)  { Timecop.return }

  let(:notifier) { Notifier.new }


  context "enqueuing reminders" do

    let!(:vaccine)    { create(:vaccine_with_doses_by_age) }
    let!(:subscriber) { create(:subscriber, next_message_at: Date.new(2013)) }
    let!(:child)      { create(:child, :with_vaccinations, :with_subscriptions, parent: subscriber, date_of_birth: Date.new(2012, 6, 10)) }

    before(:each) do
      ReminderUpcomingDose.any_instance.stub(:delta).and_return(-1.week)
      ReminderCurrentDose.any_instance.stub(:delta).and_return(0)
      ReminderAfterDose.any_instance.stub(:delta).and_return(+1.week)
    end


    context "with single subscription" do


      it "should not send reminders before date" do
        notifier.should_not_receive(:send_reminders)
        notifier.run!
      end


      context "on first dose" do

        let(:reminders) { child.vaccinations[0].reminders }


        context "with upcoming reminder" do

          (3..3).each do |day|
            it "should send upcoming dose reminder on day #{day}" do
              Timecop.freeze(Time.utc(2013,6,day))
              expected_reminder = reminders[0]
              
              notifier.should_receive(:send_reminders).with([expected_reminder], subscriber)
              notifier.run!

              expected_reminder.reload.status.should eq("sending")
              subscriber.reload.next_message_at.should be_during(2013,6,10)
            end
          end

        end


        context "with current reminder" do

          (10..16).each do |day|

            it "should send current dose reminder on day #{day} after upcoming dose reminder" do
              Timecop.freeze(Time.utc(2013,6,day))
              reminders[0].update_attributes status: 'sent', sent_at: 1.week.ago

              expected_reminder = reminders[1]

              notifier.should_receive(:send_reminders).with([expected_reminder], subscriber)        
              notifier.run!

              expected_reminder.reload.status.should eq("sending")
              subscriber.reload.next_message_at.should be_during(2013,6,17)
            end

            it "should send current dose reminder on day #{day} skipping upcoming dose reminder" do
              Timecop.freeze(Time.utc(2013,6,day))
              expected_reminder = reminders[1]

              notifier.should_receive(:send_reminders).with([expected_reminder], subscriber)        
              notifier.run!

              reminders[0].reload.status.should eq('expired')
              expected_reminder.reload.status.should eq("sending")
              subscriber.reload.next_message_at.should be_during(2013,6,17)
            end

          end

        end


        context "with afterwards reminder" do

          before(:each) { Timecop.freeze(Time.utc(2013,6,17)) }

          it "should send post dose reminder after current dose reminder" do
            reminders[0].update_attributes status: 'sent', sent_at: 2.weeks.ago
            reminders[1].update_attributes status: 'sent', sent_at: 1.week.ago

            expected_reminder = reminders[2]

            notifier.should_receive(:send_reminders).with([expected_reminder], subscriber)
            notifier.run!

            expected_reminder.reload.status.should eq("sending")
            subscriber.reload.next_message_at.should be_during(2014,6,3)
          end

          it "should send post dose reminder skipping current dose reminder if it was not sent" do
            reminders[0].update_attributes status: 'expired', sent_at: 2.weeks.ago

            expected_reminder = reminders[2]

            notifier.should_receive(:send_reminders).with([expected_reminder], subscriber)
            notifier.run!

            reminders[1].reload.status.should eq('expired')
            expected_reminder.reload.status.should eq("sending")
            subscriber.reload.next_message_at.should be_during(2014,6,3)
          end

          it "should mark current vaccination as past when last reminder is sent" do
            reminders[0].update_attributes status: 'sent', sent_at: 2.weeks.ago
            reminders[1].update_attributes status: 'sent', sent_at: 1.week.ago

            notifier.should_receive(:send_reminders).with([reminders[2]], subscriber)
            notifier.run!

            child.vaccinations[0].reload.status.should eq('past')
            subscriber.reload.next_message_at.should be_during(2014,6,3)
          end

        end

      end


      context "after first dose" do

        let(:reminders) { child.vaccinations[1].reminders }

        before(:each) do
          child.vaccinations[0].tap do |v|
            v.status = 'past'
            v.reminders.each do |r|
              r.status = 'sent'
              r.save!
            end
          end.save!
        end

        it "should not send next dose notification before date" do
          Timecop.freeze(Time.utc(2014,1,1))
          notifier.should_not_receive(:send_reminders)
          notifier.run!
        end

        it "should send upcoming reminder for second dose" do
          Timecop.freeze(Time.utc(2014,6,3))
          expected_reminder = reminders[0]
              
          notifier.should_receive(:send_reminders).with([expected_reminder], subscriber)
          notifier.run!

          expected_reminder.reload.status.should eq("sending")
          subscriber.reload.next_message_at.should be_during(2014,6,10)
        end

      end


      context "on last dose" do

        let(:reminders) { child.vaccinations[2].reminders }

        before(:each) do
          child.vaccinations[0..1].each do |v|
            v.status = 'past'
            v.reminders.each do |r|
              r.status = 'sent'
              r.save!
            end
            v.save!
          end
        end

        it "should mark vaccination as past after last reminder is sent" do
          Timecop.freeze(Time.utc(2015,6,17))
          reminders[0].update_attributes status: 'sent', sent_at: 2.weeks.ago
          reminders[1].update_attributes status: 'sent', sent_at: 1.week.ago

          expected_reminder = reminders[2]
          child.vaccinations[2].status.should eq('planned')
              
          notifier.should_receive(:send_reminders).with([expected_reminder], subscriber)
          notifier.run!

          child.vaccinations[2].reload.status.should eq('past')
          subscriber.reload.next_message_at.should be_nil
        end

      end


      context "after all doses" do

        before(:each) do
          child.vaccinations.each do |v|
            v.status = 'past'
            v.reminders.each do |r|
              r.status = 'sent'
              r.save!
            end
            v.save!
          end
        end

        it "should not send any messages after last dose" do
          Timecop.freeze(Time.utc(2016,1,1))
          notifier.should_not_receive(:send_reminders)
          notifier.run!
        end

      end


    end

  end
end