require 'spec_helper'

describe NuntiumController do
  sms_number = "12345678"
  it "receives at and replies nothing" do
    # Nuntium.any_instance.should_receive(:process).with('body' => 'foo')

    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{Settings.nuntium.incoming_username}:#{Settings.nuntium.incoming_password}")
    get :receive_at, 'body' => 'foo'

    response.should be_success
    response.body.should be_blank
  end

  it "receives at 'alta' msg and creates channel" do
    Nuntium.any_instance.should_receive(:send_ao).with(:body => 'Bienvenido a Inmuniversia', :from => "sms://#{Settings.nuntium.sms_from}", :to => "sms://#{sms_number}")

    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{Settings.nuntium.incoming_username}:#{Settings.nuntium.incoming_password}")
    Channel::Sms.count.should eq(0)
    get :receive_at, 'body' => 'alta', 'number' => sms_number
    Channel::Sms.count.should eq(1)
    Channel::Sms.last.address.should eq(sms_number)

    response.should be_success
    # response.body.should eq('Bienvenido a Inmuniversia')
    # response.content_type.should eq('text/plain')
  end

  it "receives at 'ALTA' msg and creates channel" do
    Nuntium.any_instance.should_receive(:send_ao).with(:body => 'Bienvenido a Inmuniversia', :from => "sms://#{Settings.nuntium.sms_from}", :to => "sms://#{sms_number}")
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{Settings.nuntium.incoming_username}:#{Settings.nuntium.incoming_password}")
    Channel::Sms.count.should eq(0)
    get :receive_at, 'body' => 'ALTA', 'number' => sms_number
    Channel::Sms.count.should eq(1)
    Channel::Sms.last.address.should eq(sms_number)

    response.should be_success
    # response.body.should eq('Bienvenido a Inmuniversia')
    # response.content_type.should eq('text/plain')
  end

  it "performs basic http auth" do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("wrong:wrong")

    get :receive_at, 'body' => 'foo'

    response.code.should eq('401')
  end
end