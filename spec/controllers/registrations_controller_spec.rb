require 'spec_helper'

describe Subscribers::RegistrationsController do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:subscriber]
  end

  context "on sms_user sign up" do
    context "subscriber_from_mobile" do
      it "creates a new channel" do
        get :subscriber_from_mobile
        assigns(:channel).should be_kind_of(Channel::Sms)
      end
    end

    context "find_subscriber_and_send_verification_code" do
      let!(:subscriber) {create(:subscriber)}
      let!(:channel) {create(:sms_channel)}
      let!(:subscriber_sms) {Subscriber.create_sms_subscriber("12345678")}
      before(:each) {}
      it "sends the verification code if the channel exists and the subscriber is sms_only" do
        Nuntium.any_instance.should_receive(:send_ao)
        channel_sms = subscriber_sms.sms_channels.first
        channel_sms.verification_code.should be_nil
        post :find_subscriber_and_send_verification_code, channel_sms: {address: "12345678"}
        channel_sms.reload.verification_code.should be_kind_of(String)
      end

      it "dont sends the verification code if the channel exists but the subscriber is not sms_only" do
        subscriber.sms_only = false
        subscriber.channels = [channel]
        subscriber.save
        Nuntium.any_instance.should_receive(:send_ao).never
        channel.verification_code.should be_nil
        post :find_subscriber_and_send_verification_code, channel_sms: {address: channel.address}
        channel.verification_code.should be_nil

        flash[:alert].should =~ /Ya existe un usuario web con ese numero/m
        response.should redirect_to(root_path)
      end

      it "does nothing if the channel does not exist" do
        Nuntium.any_instance.should_receive(:send_ao).never
        expect do
          post :find_subscriber_and_send_verification_code, channel_sms: {address: "111111111111"}
        end.to change(Channel, :count).by(0)

        flash[:alert].should =~ /No se encontro un usuario registrado con ese numero/m
        response.should redirect_to(subscribers_subscriber_from_mobile_url)
      end

    end

    context "submit_verification_code_and_fulfill_user_data" do

      it "redirects if no id parameter is passed" do
        post :submit_verification_code_and_fulfill_user_data
        response.should redirect_to(root_url)
      end

    end

  end

  context "on normal sign_up" do

    context "index" do

      let!(:valid_attributes) {{:first_name => "Jose", :last_name => "Test", :email => "test@manas.com", :password => "12345678", :password_confirmation => "12345678", :zip_code => "1234"}}
      let!(:invalid_attributes1) {{:first_name => "Jose", :last_name => "Test", :email => "test@manas.com", :password => "12345678", :password_confirmation => "1234568", :zip_code => "1234"}}
      let!(:invalid_attributes2) {{:first_name => "Jose", :last_name => "Test", :email => "test@manas", :password => "12345678", :password_confirmation => "12345678", :zip_code => "1234"}}

      it "should have a success response" do
        get :new
        response.should be_success
      end

      it "should create a subscriber with valid attributes, and log in with it" do
        expect do
          post :create, {:subscriber => valid_attributes}
        end.to change(Subscriber, :count).by(1)
        warden.authenticated?(:subscriber).should be_true
      end

      it "should not create a subscriber with invalid attributes" do
        expect do
          post :create, {:subscriber => invalid_attributes1}
        end.to change(Subscriber, :count).by(0)
        expect do
          post :create, {:subscriber => invalid_attributes2}
        end.to change(Subscriber, :count).by(0)
      end
    end

    context "mobile_configuration" do

      let!(:subscriber) {create(:subscriber)}
      before(:each) {sign_in subscriber}

      it "should have a successful request" do
        get :mobile_configuration
        response.should be_success
      end

      it "should create a channel with valid attributes and send verification code" do
        Nuntium.any_instance.should_receive(:send_ao)
        expect do
          post :add_mobile_number_and_send_verification_code, {:channel_sms =>{:address => "12342"}}
        end.to change(Channel, :count).by(1)
      end

      it "should not create a subscriber with invalid attributes" do
        Nuntium.any_instance.should_receive(:send_ao).never
        expect do
          post :add_mobile_number_and_send_verification_code, {:channel_sms =>{:address => "123a"}}
        end.to change(Channel, :count).by(0)
        expect do
          post :add_mobile_number_and_send_verification_code, {:channel_sms =>{:address => "asdase"}}
        end.to change(Channel, :count).by(0)
      end
    end

    context "confirm code" do
      let!(:subscriber) {create(:subscriber)}
      let!(:channel) {create(:sms_channel, address: "1234512", verification_code: 666)}
      before(:each) {sign_in subscriber}

      it "should confirm the channel with the valid code" do
        post :submit_verification_code, {:id => channel.id, :verification_code => [channel.verification_code]}
        Channel.find(channel.id).verification_code.should eq("verified")
        response.should redirect_to(dashboard_path)
      end

      it "should not confirm the channel with an invalid code" do
        post :submit_verification_code, {:id => channel.id, :verification_code => [channel.verification_code + 1]}
        Channel.find(channel.id).verification_code.should eq("666")
        response.body.should =~ /ingresado no coincide/m
      end

      it "should resend the verification code" do
        Nuntium.any_instance.should_receive(:send_ao)
        post :add_mobile_number_and_send_verification_code, {:channel_sms_resend => channel.id}
        Channel.find(channel.id).verification_code.should eq("666")
        response.body.should =~ /Te reenviamos el/m
      end
    end
  end
end