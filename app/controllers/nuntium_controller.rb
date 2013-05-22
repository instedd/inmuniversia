class NuntiumController < ApplicationController

  before_filter :authenticate
  skip_before_filter :verify_authenticity_token

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == Settings.nuntium.incoming_username && password == Settings.nuntium.incoming_password
    end
  end

  def receive_at
    # data = Command.process params.except(:action, :controller)
    #sacar esto a una clase apropiada
    if params[:from] && (params[:body].downcase.match /^alta/i)
      subscriber = Subscriber.create_sms_subscriber(params[:from])
      render text: "Bienvenido a Inmuniversia", content_type: 'text/plain'
    else
      head :ok
    end
  end
end
