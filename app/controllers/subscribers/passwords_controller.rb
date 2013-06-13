# encoding: utf-8

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

class Subscribers::PasswordsController < Devise::PasswordsController

  def create
    @forgot_password_resource = self.resource = Subscriber.send_reset_password_instructions(params[resource_name])
    if successfully_sent?(resource)
      flash[:notice] = "Se ha enviado un mail con las instrucciones para recuperar la contraseña a #{resource.email}."
      redirect_to home_path
    else
      render 'home/index'
    end
  end

end