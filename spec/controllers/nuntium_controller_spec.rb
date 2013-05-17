require 'spec_helper'

describe NuntiumController do
  sms_number = "12345678"
  it "receives at and replies nothing" do
    # Nuntium.any_instance.should_receive(:process).with('body' => 'foo')
    #sacar esto a un modulo que inicializo en spec_helper, y le paso los parametros de user y pass
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{Settings.nuntium.incoming_username}:#{Settings.nuntium.incoming_password}")
    post :receive_at, 'body' => 'foo'

    response.should be_success
    response.body.should be_blank
  end

  it "receives at 'alta' msg and creates channel" do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{Settings.nuntium.incoming_username}:#{Settings.nuntium.incoming_password}")
    #expect to change 1 y juntar los dos tests en un each
    Channel::Sms.count.should eq(0)
    post :receive_at, :body => 'alta', :from => sms_number
    Channel::Sms.count.should eq(1)
    Channel::Sms.last.address.should eq(sms_number)

    response.should be_success
    response.body.should eq('Bienvenido a Inmuniversia')
    response.content_type.should eq('text/plain')
  end

  it "receives at 'ALTA' msg and creates channel" do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{Settings.nuntium.incoming_username}:#{Settings.nuntium.incoming_password}")
    Channel::Sms.count.should eq(0)
    post :receive_at, :body => 'ALTA', :from => sms_number
    Channel::Sms.count.should eq(1)
    Channel::Sms.last.address.should eq(sms_number)

    response.should be_success
    response.body.should eq('Bienvenido a Inmuniversia')
    response.content_type.should eq('text/plain')
  end

  it "performs basic http auth" do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("wrong:wrong")

    post :receive_at, 'body' => 'foo'

    response.code.should eq('401')
  end
end