class Subscribers::SessionsController < Devise::SessionsController

  def new
    @login_resource = resource = build_resource
    clean_up_passwords(resource)
    render 'home/index'
  end

  def create
    @login_resource = resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

end