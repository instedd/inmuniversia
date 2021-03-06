source 'https://rubygems.org'

gem 'rails', '~> 3.2.0'

gem 'mysql2'

gem 'json'
gem 'devise'
gem 'haml-rails'
gem 'jquery-rails', '~> 2.0.0'
gem 'acts_as_list'
gem 'enumerize'
gem 'delayed_job_active_record'
gem 'rails_config'
gem 'nuntium_api'
gem 'newrelic_rpm'
gem 'therubyracer'
gem 'less-rails', "~> 2.3.3"
gem 'bootstrap-datepicker-rails'
gem 'dynamic_form'
gem 'js-routes'
gem 'gon'
gem 'acts_as_commentable_with_threading'
gem 'foreman', '~> 0.64.0'

# We are using timecop for scaling time in dev and production for testing purposes
gem 'timecop'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier',     '>= 1.0.3'
  gem 'handlebars_assets'
end

group :webserver do
  gem 'puma', '~> 3.0.2'
end

group :development do
  gem 'capistrano',         '~> 3.4.1', :require => false
  gem 'capistrano-rails',   '~> 1.2', :require => false
  gem 'capistrano-bundler', '~> 1.2', :require => false
  gem 'net-ssh',            '~> 2.8', :require => false
  gem 'thin'
  gem 'html2haml'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'pry-debugger'
  gem 'licit'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'ci_reporter'
  gem 'cover_me'
end

# Refinery
gem 'refinerycms-core'
gem 'refinerycms-settings'
gem 'refinerycms-dashboard'
gem 'refinerycms-images'
gem 'refinerycms-pages'
gem 'refinerycms-resources'

# Custom engines
gem 'refinerycms-vaccines', :path => 'vendor/extensions'
