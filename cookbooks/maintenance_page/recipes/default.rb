#
# Cookbook Name:: maintenance_page
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2-maintenance::default"

include_recipe "sudo::default"

include_recipe "elb::default"


template "#{node["elb"]["scripts_home"]}/elb_deregister_ec2_from_elb.sh" do
  source "elb_deregister.erb"
  mode "0755"
    variables(
    :elbs => node["elb"]["names"]
  )
end

template "#{node["elb"]["scripts_home"]}/elb_register_ec2_to_elb.sh" do
  source "elb_register.erb"
  mode "0755"
      variables(
    :elbs => node["elb"]["names"]
  )
end

template "#{node["elb"]["scripts_home"]}/elb_change_health_check.sh" do
  source "elb_change_health_check.erb"
  mode "0755"
      variables(
    :elbs => node["elb"]["names"]
  )
end


cookbook_file "/var/www/index.html" do
	source "index.html"
	owner "root"
	group "root"
	mode "0644"
end

cookbook_file "/var/www/health_check.html" do
  source "health_check.html"
  owner "root"
  group "root"
  mode "0644"
end

template "/home/ubuntu/latency_elb.sh" do
  source "latency_elb.sh.erb"
  mode "0755"
end



# Check load run list json template
template "Check load run list json" do
  source "check_load.json.erb"
  path "/etc/chef/check_load.json"
  owner "root"
  group "root"
  mode "0644"
end

# 2 json files to be used as run list for manual switch on/off with jenkins
template "switch on run list json" do
  source "switch_on.json.erb"
  path "/etc/chef/switch_on.json"
  owner "root"
  group "root"
  mode "0644"
end
template "switch off run list json" do
  source "switch_off.json.erb"
  path "/etc/chef/switch_off.json"
  owner "root"
  group "root"
  mode "0644"
end


 
 

  



