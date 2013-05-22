# encoding: utf-8

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