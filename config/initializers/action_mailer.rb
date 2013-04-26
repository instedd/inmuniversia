require_relative 'rails_config'

ActionMailer::Base.default_url_options[:host] = Settings.hosts.local
ActionMailer::Base.delivery_method = Settings.email.delivery_method.to_sym

ActionMailer::Base.smtp_settings.merge!(Settings.email.smtp_settings.to_hash)         if Settings.email.smtp_settings
ActionMailer::Base.sendmail_settings.merge!(Settings.email.sendmail_settings.to_hash) if Settings.email.sendmail_settings