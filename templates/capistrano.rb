# Lovingly borrowed from http://frozenplague.net/2008/09/ubuntu-rails-apache-passenger-capistrano-you/

gem 'capistrano', :lib => false

rake 'gems:install', :sudo => true

run('capify .')

deployment = []

application = `pwd`[0..-2].split('/')[-1]
deployment << "set :application, '#{application}'"

scm = ask('What SCM are you using? (ie git)')
deployment << "set :scm, :#{scm}"

repository = ask('What is the path to your repository? (ie git:github.com/...)')
deployment << "set :repository, '#{repository}'"

app = ask('What is the hostname of your app server?')
deployment << "set :app, '#{app}'"

web = ask('What is the hostname of your web server?')
deployment << "set :web, '#{web}'"

db = ask('What is the hostname of your primary db server?')
deployment << "set :db, '#{db}', :primary => true"

deploy_to = ask('What is the full path you deploy to? (ie /home/deploy/app)')
deployment << "set :deploy_to, '#{deploy_to}'"

file_append('config/deploy.rb', deployment.join("/n"))

if yes?('Does your webserver run Passenger (mod_rails)?')
  file_append('config/deploy.rb'), <<-DEP

namespace :passenger do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

# For deploying a database.yml file.
namespace :deploy do
 task :after_update_code, :roles => :app do
   run "ln -nfs #{deploy_to}/shared/system/database.yml #{release_path}/config/database.yml"
 end

after :deploy, "passenger:restart
DEP
end

git :add => '.'
git :commit => "-a -m 'Added Capistrano and capified'"
