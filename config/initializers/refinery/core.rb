# encoding: utf-8
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

Refinery::Core.configure do |config|
  # When true will rescue all not found errors and display a friendly error page
  config.rescue_not_found = Rails.env.production?

  # When true this will force SSL redirection in all Refinery backend controllers.
  # config.force_ssl = false

  # When true will use Amazon's Simple Storage Service instead of
  # the default file system for storing resources and images
  config.s3_backend = !(ENV['S3_KEY'].nil? || ENV['S3_SECRET'].nil?)

  # Whenever Refinery caches anything and can set a cache key, it will add
  # a prefix to the cache key containing the string you set here.
  # config.base_cache_key = :refinery

  # Site name
  config.site_name = "Inmuniversia"

  # This activates Google Analytics tracking within your website. If this
  # config is left blank or set to UA-xxxxxx-x then no remote calls to
  # Google Analytics are made.
  config.google_analytics_page_code = Settings.analytics.google

  # Enable/disable authenticity token on frontend
  # config.authenticity_token_on_frontend = true

  # Hide/show child pages in menu
  # config.menu_hide_children = false

  # CSS class selectors for menu helper
  # config.menu_css = {:selected=>"selected", :first=>"first", :last=>"last"}

  # Should set this if concerned about DOS attacks. See
  # http://markevans.github.com/dragonfly/file.Configuration.html#Configuration
  # config.dragonfly_secret = "ee5387b1a861662b6b501fea8c877b2fa95a6f7acebfe060"

  # Show/hide IE6 upgrade message in the backend
  config.ie6_upgrade_message_enabled = true

  # Show/hide browser update message in the backend
  config.show_internet_explorer_upgrade_message = true

  # Add extra tags to the wymeditor whitelist e.g. = {'tag' => {'attributes' => {'1' => 'href'}}} or just {'tag' => {}}
  # config.wymeditor_whitelist_tags = {}

  # Register extra javascript for backend
  # config.register_javascript "prototype-rails"

  # Register extra stylesheet for backend (optional options)
  # config.register_stylesheet "custom", :media => 'screen'
end
