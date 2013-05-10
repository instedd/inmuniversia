module LoginHelper

  def render_login_form
    render 'subscribers/sessions/form', resource: Subscriber.new, resource_name: 'subscriber', devise_mapping: Devise.mappings[:subscriber]
  end

end