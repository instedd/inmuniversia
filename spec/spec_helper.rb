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
  config.include MailHelpers
  config.include DelayedJobHelpers
  config.include NuntiumHelpers

  config.before(:all) do
    User.new(email: 'admin@example.com', password: 'ChangeMe').create_first if User.count == 0
  end

  config.before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  config.after(:each) do
    Timecop.return
  end

  # Ignore tests
  def ignore(*args); end;

  # Uncomment to view full backtraces
  # config.backtrace_clean_patterns = []
end
