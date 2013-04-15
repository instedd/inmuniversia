ENV["RAILS_ENV"] ||= 'test'
require 'cover_me'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.render_views = true
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller

  config.before(:all) do
    User.new(email: 'admin@example.com', password: 'ChangeMe').create_first if User.count == 0
  end

  # Uncomment to view full backtraces
  # config.backtrace_clean_patterns = []
end
