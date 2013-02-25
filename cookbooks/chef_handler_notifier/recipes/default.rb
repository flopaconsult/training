#
# Cookbook Name:: chef_handler_notifier
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

pony_install= execute "pony_install" do
 command "gem install pony"
  creates "/var/lib/pony.install"
  action :nothing
end
pony_install.run_action(:run)

Gem.clear_paths

myfile = cookbook_file "/var/chef/handlers/email_me.rb" do
  source "email_me" 
  mode 00644
end
myfile.run_action(:create)

chef_handler "MyOrganization::EmailMe" do
  source "/var/chef/handlers/email_me"
  arguments "flopaconsult@gmail.com"
  # in order to send notifications only in case of exceptions
  #supports :exception => true
  action :nothing
end.run_action(:enable)

