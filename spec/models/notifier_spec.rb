require 'spec_helper'

describe Notifier do

  before(:each) { Timecop.freeze(Time.utc(2013,1,1,12,0,0)) }

  let(:notifier) { Notifier.new }

  context "choosing subscribers" do 

    it "should not process subscribers with empty next message date" do
      subscriber = create(:subscriber, next_message_at: nil)
      notifier.should_not_receive(:notify_subscriber).with(subscriber)
      notifier.run!
    end

    it "should process subscribers with past next message date" do
      subscriber = create(:subscriber, next_message_at: Date.new(2012,12,31))
      notifier.should_receive(:notify_subscriber).with(subscriber)
      notifier.run!
    end

    it "should process subscribers with current next message date" do
      subscriber = create(:subscriber, next_message_at: Date.new(2013,1,1))
      notifier.should_receive(:notify_subscriber).with(subscriber)
      notifier.run!
    end

    it "should not process subscribers with future next message date" do
      subscriber = create(:subscriber, next_message_at: Date.new(2013,1,2))
      notifier.should_not_receive(:notify_subscriber).with(subscriber)
      notifier.run!
    end

  end

end
