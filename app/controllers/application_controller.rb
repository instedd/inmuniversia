class ApplicationController < ActionController::Base
  protect_from_forgery

  def self.set_body_class(klazz, opts={})
    before_filter opts do
      @body_class = klazz
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Subscriber)
      dashboard_path
    else
      refinery.admin_dashboard_path
    end
  end

end
