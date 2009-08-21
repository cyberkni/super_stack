SOURCE = "vendor/plugins/super_stack" unless defined? SOURCE
load_template("#{SOURCE}/templates/helper.rb") unless self.respond_to? :file_inject

##############################
# RSpec
##############################
gem 'rspec', :lib => false, :version => '>= 1.2.8', :env => 'test'
gem 'rspec-rails', :lib => false, :version => '>= 1.2.7.1', :env => 'test'
gem 'remarkable', :lib => false, :version => '>=3.1.8', :env => 'test'
gem 'remarkable_activerecord', :lib => false, :version => '>=3.1.8', :env => 'test'
gem 'remarkable_rails', :lib => false, :version => '>=3.1.8', :env => 'test'
gem 'notahat-machinist', :lib => false,
  :source => 'http://gems.github.com', :env => 'test'
gem 'thoughtbot-shoulda', :lib => false, :version => '>=2.10.1',
  :source => 'http://gems.github.com', :env => 'test'

rake 'gems:install', :sudo => true, :env => 'test'
 
generate :rspec

# remove test dir
if yes?('Do you want to get rid of the test directory entirely?')
  git :rm => '-r test'
else
  file_inject 'test/test_helper.rb', "require 'spec/rails'", <<-CODE
require 'shoulda'
require 'remarkable_rails'
require File.expand_path(File.dirname(__FILE__) + '/blueprints'
CODE
end
 
file 'spec/spec.opts', <<-CODE
--colour
--format progress
--format html:coverage/spec.html
--loadby mtime
--reverse
CODE
 
file_inject 'spec/spec_helper.rb', "require 'spec/rails'", <<-CODE
require 'shoulda'
require 'remarkable_rails'
require File.expand_path(File.dirname(__FILE__) + '/blueprints'
CODE
##############################
# Cucumber
##############################
gem 'term-ansicolor', :lib => false, :version => '>=1.0.4', :env => 'test'
gem 'treetop', :lib => false, :version => '>=1.3.0', :env => 'test'
gem 'diff-lcs', :lib => false, :version => '>=1.1.2', :env => 'test'
gem 'nokogiri', :lib => false, :version => '>=1.3.3', :env => 'test'
gem 'builder', :lib => false, :version => '>=2.1.2', :env => 'test'
gem 'cucumber', :lib => false, :version => '>=0.3.92', :env => 'test'
gem 'webrat', :lib => false, :version => '>=0.4.4', :env => 'test'
gem 'bmabey-email_spec', :lib => 'email_spec', :version => '>=0.2.0',
  :source => 'http://gems.github.com', :env => 'test'
gem 'ruby-debug-base', :lib => false, :version => '>=0.10.3', :env => 'test'
gem 'ruby-debug', :lib => false, :version => '>=0.10.3', :env => 'test'
 
# we still need 'test' environment to install cucumber related gems
rake 'gems:install', :sudo => true, :env => 'test'
 
generate :cucumber
 
# Write gem config to 'cucumber' environment for cucumber >=0.3.8
gem 'bmabey-email_spec', :lib => 'email_spec', :version => '>=0.2.1',
  :source => 'http://gems.github.com', :env => 'cucumber'
 
file 'cucumber.yml', <<-CODE
default: -r features features
autotest: -r features --format pretty
autotest-all: -r features --format progress
CODE
 
file_append 'features/support/env.rb', <<-CODE
require 'email_spec/cucumber'
CODE
 
generate :email_spec
 
file 'features/step_definitions/custom_email_steps.rb', <<-CODE
CODE
 
file_inject 'spec/spec_helper.rb', "require 'spec/rails'", <<-CODE
require 'email_spec/helpers'
require 'email_spec/matchers'
CODE
 
file_inject 'spec/spec_helper.rb', "Spec::Runner.configure do |config|", <<-CODE
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
CODE
 
##############################
# RCov & Autotest
##############################
gem 'spicycode-rcov', :lib => 'rcov', :version => '>=0.8.2.1',
  :source => 'http://gems.github.com', :env => 'test'
gem 'ZenTest', :lib => 'autotest', :version => '>=4.1.1', :env => 'test'
gem 'carlosbrando-autotest-notification', :lib => 'autotest_notification', :version => '>=1.9.1',
  :source => 'http://gems.github.com', :env => 'test'
 
rake 'gems:install', :sudo => true, :env => 'test'
 
file 'spec/rcov.opts', <<-CODE
--exclude "spec/*,gems/*,features/*"
--rails
--aggregate "coverage.data"
CODE
 
run 'an-install'
#run 'an-uninstall'
 
file_append 'config/environments/test.rb', <<-CODE
 
ENV['AUTOFEATURE'] = "true"
ENV['RSPEC'] = "true"
CODE
 
##############################
# Misc
##############################
file_append 'features/support/env.rb', <<-CODE
 
# http://authlogic.rubyforge.org/classes/Authlogic/TestCase.html
require 'authlogic/test_case'
include Authlogic::TestCase
#setup :activate_authlogic
 
# http://www.tzi.org/~sbartsch/declarative_authorization/master/classes/Authorization/Maintenance.html
require 'declarative_authorization/maintenance'
include Authorization::Maintenance
 
CODE

if git?
  git :submodule => "init"
  git :submodule => "update"
  git :add => "config lib script spec features cucumber.yml"
  git :commit => "-m 'setup testing suite'"
end
