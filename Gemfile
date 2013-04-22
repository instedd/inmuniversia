source 'https://rubygems.org'

gem 'rails', '3.2.13'

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

# We are using timecop for scaling time in dev and production for testing purposes
gem 'timecop'

# Refinery
gem 'refinerycms-core'
gem 'refinerycms-dashboard'
gem 'refinerycms-images'
gem 'refinerycms-pages'
gem 'refinerycms-resources'

# Custom engines
gem 'refinerycms-vaccines', :path => 'vendor/extensions'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'capistrano'
  gem 'rvm'
  gem 'rvm-capistrano'
  gem 'thin'
  gem 'html2haml'
  gem "better_errors"
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'ci_reporter'
  gem 'cover_me'
end
