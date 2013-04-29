class ApplicationController < ActionController::Base
  protect_from_forgery

  def self.set_body_class(klazz, opts={})
    before_filter opts do
      @body_class = klazz
    end
  end
end
