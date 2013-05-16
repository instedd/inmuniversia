class NuntiumController < ApplicationController

  before_filter :authenticate

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == Settings.nuntium.incoming_username && password == Settings.nuntium.incoming_password
    end
  end

  def receive_at
    # data = Command.process params.except(:action, :controller)
    #sacar esto a una clase apropiada
    if params[:number] && (params[:body].downcase.match /^alta/i)
      channel = Channel::Sms.create!(:address => params[:number])
      channel.send_message("Bienvenido a Inmuniversia")
      # render text: "Bienvenido a Inmuniversia", content_type: 'text/plain'
      head :ok
    else
      head :ok
    end
  end
end
