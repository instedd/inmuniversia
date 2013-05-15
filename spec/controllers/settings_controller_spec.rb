require 'spec_helper'

describe SettingsController do

  let(:subscriber) { create(:subscriber) }
  before(:each)    {sign_in subscriber}

  it "should update setting for subscriber" do
    xhr :put, :update_preferences, preferences: {'dashboard.active_tab' => 'agenda'}
    subscriber.reload.preferences['dashboard.active_tab'].should eq('agenda')
  end

end