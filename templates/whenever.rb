gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'

file_append 'config/environment.rb', <<-WHEN

require 'whenever'
WHEN

rake 'gems:install', :sudo => true

run 'wheneverize .'

git :add => '.'
git :commit => "-a -m 'Added support for cron jobs using Whenever'"