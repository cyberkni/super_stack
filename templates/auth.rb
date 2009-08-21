plugin 'authlogic_bundle',
  :git => 'git://github.com/tsechingho/authlogic_bundle.git'

load_template("vendor/plugins/authlogic_bundle/templates/base.rb")

run 'cp -r vendor/plugins/authlogic_bundle/app/* app/'

SOURCE = "vendor/plugins/authlogic_bundle" unless defined? SOURCE
load_template("#{SOURCE}/templates/helper.rb") unless self.respond_to? :file_inject
