#hoptoad -> config info at http://github.com/thoughtbot/hoptoad_notifier/tree/master
plugin 'hoptoad_notifier',
  :git => 'git://github.com/thoughtbot/hoptoad_notifier.git'

rake 'gems:install', :sudo => true

key = ask('What is your Hoptoad API key?')
if key
  hop = "HoptoadNotifier.configure do |config|\n  config.api_key = '#{key}'\nend"
  file 'config/initializers/hoptoad.rb', hop
end

git :add => '.'
git :commit => "-a -m 'Added support for Hoptoad Exception Notification'"