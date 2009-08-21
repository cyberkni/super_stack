#twitter4r
gem 'twitter4r', :lib => 'twitter'

gem 'daemons'
gem 'rubigen'

#twibot
gem 'twibot', :lib => false, :source => 'http://gems.github.com'

gem 'bhauman-twroute', :lib => 'twroute', :source => 'http://gems.github.com'
# in theory there should be config options for twroute here too...

rake 'gems:install', :sudo => true

twitter_user = ask('What is the username your Twitter bot will be using?')
twitter_pass = ask('What is the password your Twitter bot will be using?')
bot_config = "login: #{twitter_user}\npassword: #{twitter_pass}"
file 'config/bot.yml', bot_config


#gem 'oauth'
#gem 'authlogic-oauth', :lib => 'authlogic_oauth'

#rake 'gems:install', :sudo => true

#timestamp = `date +%Y%m%d%H%M%S`[0..-2]

#file "db/migrate/#{timestamp}_add_users_oauth_fields.rb", <<-OAUTH
#class AddUsersOauthFields < ActiveRecord::Migration
#    def self.up
#      add_column :users, :oauth_token, :string
#      add_column :users, :oauth_secret, :string
#      add_index :users, :oauth_token

#    end

#    def self.down
#      remove_column :users, :oauth_token
#      remove_column :users, :oauth_secret

#      User.all(:conditions => :login is NULL).each { |user| user.update_attribute(:login, ") if user.send(:login).nil? "}
#      change_column :users, :login, :string, :default => "", :null => false
#      User.all(:conditions => :crypted_password is NULL).each { |user| user.update_attribute(:crypted_password, ") if user.send(:crypted_password).nil? "}
#      change_column :users, :crypted_password, :string, :default => "", :null => false
#      User.all(:conditions => :password_salt is NULL).each { |user| user.update_attribute(:password_salt, ") if user.send(:password_salt).nil? "}
#      change_column :users, :password_salt, :string, :default => "", :null => false
#
#    end
#end
#OAUTH

#rake 'db:migrate'

#file_inject 'app/models/user_session.rb', 'class UserSession < Authlogic::Session::Base', <<-ADDME
#
#    def self.oauth_consumer
#      OAuth::Consumer.new("TOKEN", "SECRET",
#      { :site=>"http://twitter.com",
#        :authorize_url => "http://twitter.com/oauth/authenticate" })
#    end
#    
#ADDME

#file 'app/views/users/app/views/users/new.html.erb', '  <%= f.text_field :openid_identifier %>', <<-ADDME
#</p>
#<p>
#  <%= oauth_register_button :value => "Register with Twitter" %>
#  <%= oauth_login_button :value => "Login with Twitter" %>
#<p>
#ADDME

git :add => '.'
git :commit => "-a -m 'Added Twitter support'"
