#gravtasic
gem 'gravtastic', :version => '>= 2.1.0' # see http://github.com/chrislloyd/gravtastic/tree/master

rake 'gems:install', :sudo => true

file_inject 'app/models/user.rb', 'class User < ActiveRecord::Base', <<-GRAV
  is_gravtastic!
GRAV

git :add => '.'
git :commit => "-a -m 'Added support for Gravitars'"