# Copyright (C) 2013, InSTEDD
#
# This file is part of Inmuniversia.
#
# Inmuniversia is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Inmuniversia is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Inmuniversia.  If not, see <http://www.gnu.org/licenses/>.

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
