# This script owes MUCH to app_lego and authlogic_bundle

# remove tmp dirs
run "rmdir tmp/{pids,sessions,sockets,cache}"

# remove unnecessary stuff
run "rm README log/*.log public/index.html public/images/rails.png"

# keep empty dirs
run("find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;")

# init git repo
git :init

# basic .gitignore file
file '.gitignore', 
%q{log/*.log
log/*.pid
db/*.db
db/*.sqlite3
db/schema.rb
tmp/**/*
.DS_Store
doc/api
doc/app
config/database.yml
autotest_result.html
coverage
public/javascripts/*_[0-9]*.js
public/stylesheets/*_[0-9]*.css
public/attachments
}

# copy sample database config
run "cp config/database.yml config/database.yml.sample"

log "initialized", "application structure"

# commit changes
git :add => "."
git :commit => "-a -m 'Setting up a new rails app. Copy config/database.yml.sample to config/database.yml and customize.'"

if yes?('Do you want to vendor Rails (2-3-3)?')

  run 'rake rails:freeze:edge RELEASE=2.3.3'

  git :commit => "-a -m 'Pinned Rails to branch 2-3-3'"
end

gem 'rack', :lib => false
gem 'sqlite3-ruby', :lib => false
rake 'gems:install', :sudo => true

if yes?('Will you need to be doing crazy :has_many :through nestings?')
  plugin 'nested_has_many_through',
    :git => 'git://github.com/ianwhite/nested_has_many_through.git'
  git :add => '.'
  git :commit => "-a -m 'Added support nested has_many through relationships'"
end

load_template('vendor/plugins/super_stack/templates/testing.rb') if yes?('Do you want to install Shoulda, Cucumber, and autotest?')
load_template('vendor/plugins/super_stack/templates/auth.rb') if yes?('Do you want authenticated users?')
load_template("vendor/plugins/authlogic_bundle/templates/monitor.rb") if yes?("Do you want to include bundled monitor suite? (y/n)")

load_template('vendor/plugins/super_stack/templates/jquery.rb') if yes?('Do you want to install jQuery?')

#misc

load_template("vendor/plugins/super_stack/templates/gmail.rb") if yes?('Do you plan to send mail through GMail?')

load_template("vendor/plugins/super_stack/templates/grav.rb") if yes?('Do you want to use Gravatars for your users?')

load_template("vendor/plugins/super_stack/templates/mobile.rb") if yes?('Will this app be accessed by mobiles?')

load_template("vendor/plugins/super_stack/templates/hoptoad.rb") if yes?('Will you be using Hoptoad for your exception notification?')
  
load_template("vendor/plugins/super_stack/templates/twitter.rb") if yes?('Will this be a Twitter app?')

if yes?('Do you want to use Active Scaffold for your admin interface?')
  plugin 'active_scaffold',
    :git => 'git://github.com/activescaffold/active_scaffold.git'
  git :add => '.'
  git :commit => "-a -m 'Added support for Active Scaffold'"
end

load_template("vendor/plugins/super_stack/templates/whenever.rb") if yes?('Will you need to be running cron jobs for your app?')

load_template('vendor/plugins/super_stack/templates/capistrano.rb') if yes?('Are you going to use Capistrano for deployment?')

run 'sudo gem update'

if yes?('Do you want to vendor your gems?')
  rake 'gems:unpack:dependencies'
  git :add => '.'
  git :commit => "-a -m 'Vendored gems'"
end
log 'you will need to update the email info in config/notify.yml and add additional info to get action_mailer setup in config/environments/production.rb'
log 'you will also want to follow the active scaffold setup instructions if you are using it: http://activescaffold.com/tutorials/getting-started'
