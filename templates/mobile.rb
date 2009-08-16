#mobile-fu -> config info at http://github.com/brendanlim/tree/master
# and at http://www.intridea.com/2008/7/21/mobilize-your-rails-application-with-mobile-fu
plugin 'mobile-fu',
  :git => 'git://github.com/brendanlim/mobile-fu.git'

rake 'gems:install', :sudo => true
  
file_inject 'app/controllers/application_controller.rb', 'class ApplicationController < ActionController::Base', <<-ADDME
  has_mobile_fu  
ADDME

git :add => '.'
git :commit => "-a -m 'Added support for mobiles via mobile-fu'"