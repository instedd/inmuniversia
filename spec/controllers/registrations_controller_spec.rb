# encoding: UTF-8
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
      let!(:subscriber_sms) {Subscriber.create_sms_subscriber("12345678")}
      it "redirects if no id parameter is passed" do
        post :submit_verification_code_and_fulfill_user_data

        response.should redirect_to(root_url)
      end

      it "validates the channel if the condition code is correct" do
        sms_channel = Channel::Sms.last
        sms_channel.verification_code = "12341234"
        sms_channel.save
        post :submit_verification_code_and_fulfill_user_data, id: sms_channel.id, verification_code: ["12341234"]

        sms_channel.reload.verification_code.should eq("verified")
        assigns(:subscriber).should eq(subscriber_sms)
      end

      it "redirects to the last page if the condition code is incorrect" do
        sms_channel = Channel::Sms.last
        sms_channel.verification_code = "12341234"
        sms_channel.save
        post :submit_verification_code_and_fulfill_user_data, id: sms_channel.id, verification_code: ["1234"]

        response.should render_template("find_subscriber_and_send_verification_code")
        assigns(:error).should be_true
      end
    end

    context "update_sms_user" do
      let!(:subscriber_sms) {Subscriber.create_sms_subscriber("12345678")}
      let!(:subscriber_web) {create(:subscriber)}
      let!(:valid_attributes) {{:first_name => "Jose", :last_name => "Test", :email => "test@manas.com", :password => "12345678", :password_confirmation => "12345678", :zip_code => "1234"}}
      let!(:invalid_attributes1) {{:first_name => "Jose", :last_name => "Test", :email => "test@manas.com", :password => "12345678", :password_confirmation => "1234568", :zip_code => "1234"}}
      let!(:invalid_attributes2) {{:first_name => "Jose", :last_name => "Test", :email => "test@", :password => "12345678", :password_confirmation => "12345678", :zip_code => "1234"}}

      it "does nothing if the subscriber id is invalid" do
        subscriber_params = subscriber_web.attributes.to_options
        subscriber_params[:id] = subscriber_params[:id] + 1
        post :update_sms_user, subscriber: subscriber_params

        response.should redirect_to(root_path)
      end

      it "does nothing if the subscriber is web" do
        subscriber_params = subscriber_web.attributes.to_options
        subscriber_params[:id] = subscriber_params[:id]
        post :update_sms_user, subscriber: subscriber_params

        response.should redirect_to(root_path)
      end

      it "updates correctly the subscriber if it exists and the parameters are valid" do
        empty_subscriber = Subscriber.create(:sms_only => true)
        valid_attributes[:id] = empty_subscriber.id
        post :update_sms_user, subscriber: valid_attributes

        empty_subscriber.reload.attributes.to_options.should include(valid_attributes.except(:id, :password, :password_confirmation))
        empty_subscriber.sms_only.should be_false
        subject.current_subscriber.should eq(empty_subscriber)
      end

      it "render the same screen again if the subscriber exists but the parameters are invalid" do
        empty_subscriber = Subscriber.create(:sms_only => true)
        invalid_attributes1[:id] = empty_subscriber.id
        post :update_sms_user, subscriber: invalid_attributes1

        empty_subscriber.reload.sms_only.should be_true
        response.should render_template("submit_verification_code_and_fulfill_user_data")
        response.body.should include("Password no coincide con la confirmación")
        subject.current_subscriber.should be_nil
      end

      it "render the same screen again if the subscriber exists but the parameters are invalid" do
        empty_subscriber = Subscriber.create(:sms_only => true)
        invalid_attributes2[:id] = empty_subscriber.id
        post :update_sms_user, subscriber: invalid_attributes2

        empty_subscriber.reload.sms_only.should be_true
        response.should render_template("submit_verification_code_and_fulfill_user_data")
        response.body.should include("Email no es válido")
        subject.current_subscriber.should be_nil
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