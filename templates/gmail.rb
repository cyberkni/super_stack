gem 'tlsmail', :lib => false

rake 'gems:install', :sudo => true

file_append 'config/environments/production.rb', <<-MAIL

# required by Gmail
require 'tlsmail'
Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
 
# ActionMailer configuration
config.action_mailer.perform_deliveries = true
config.action_mailer.delivery_method = :smtp
config.action_mailer.default_charset = "utf-8"
config.action_mailer.raise_delivery_errors = true
 
ActionMailer::Base.smtp_settings = {
  :domain => "DOMAIN-HERE.COM", :user_name => 'USERNAME-HERE', :password => 'PASSWORD-HERE',
  :address => 'smtp.gmail.com', :tls => true, :port => 587, :authentication => :login
}
MAIL

git :add => '.'
git :commit => "-a -m 'Added support form mailing through GMail.'"