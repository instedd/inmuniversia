module LoginHelper

  def render_login_form
    render 'subscribers/sessions/form', 
      forgot_password_resource: @forgot_password_resource || Subscriber.new, 
      login_resource: @login_resource || Subscriber.new, 
      resource_name: 'subscriber', 
      devise_mapping: Devise.mappings[:subscriber],
      current_action: (@forgot_password_resource ? :forgot_password : :login)
  end

end