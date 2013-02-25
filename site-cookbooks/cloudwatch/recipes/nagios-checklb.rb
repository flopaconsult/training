


ruby_block "Starting nagios-checklb recipe" do
  block do
    Chef::Log.info("Starting nagios-checklb recipe")
  end
  action :create
end

include_recipe "cloudwatch::install_fog"




Gem.clear_paths
require 'rubygems'
require 'fog'



elb = Fog::AWS::ELB.new( {
#        :provider => 'AWS',
        :aws_access_key_id => node[:ec2tag][:aws_access_key_id],
        :aws_secret_access_key => node[:ec2tag][:aws_secret_access_key]
})


ruby_block "FOG based ELB object created" do
  block do
    Chef::Log.info("FOG based ELB object created...")
  end
  action :create
end

load_balancer = elb.describe_load_balancers([node[:elb][:name]])

ruby_block "Load balancer found" do
  block do
    Chef::Log.info("Load Balancer found...#{load_balancer}")
  end
  action :create
end

zones_r = load_balancer.body["DescribeLoadBalancersResult"]["LoadBalancerDescriptions"]
Chef::Log.info(zones_r)
zones = zones_r[0]["AvailabilityZones"]
Chef::Log.info(zones)



# adding zones
# zones.enable('us-east-1b', 'us-east-1c')

# removing zones
# zones.disable('us-east-1b')

# enumerating enabled zones
zones.each do |zone|
  Chef::Log.info( "====================================> AZ: " + zone )


template "#{node["cloudwatch"]["aws_cloudwatch_home"]}/bin/checklb_command_#{zone}" do
  source "checklb_command.erb"
  mode 0644
  variables(
    :script_folder => "#{node["cloudwatch"]["aws_cloudwatch_home"]}/bin",
	:av_zone => "#{zone}"
        
  )
end

template "#{node["cloudwatch"]["aws_cloudwatch_home"]}/bin/checklb_service_#{zone}" do
  source "checklb_service.erb"
  mode 0644
    variables(
	:av_zone => "#{zone}"
        
  )
end


Chef::Log.info("append to commands...........")
execute "checklb append to commands_#{zone}" do
 
  user "root"
  command "cat #{node["cloudwatch"]["aws_cloudwatch_home"]}/bin/checklb_command_#{zone} >> #{node[:nagios][:dir]}/#{node[:nagios][:config_subdir]}/commands.cfg"
  action :run
  not_if "less /etc/nagios3/conf.d/commands.cfg |grep _#{zone}"
end



Chef::Log.info("append to services...........")
execute "checklb append to services_#{zone}" do
 
  user "root"
  command "cat #{node["cloudwatch"]["aws_cloudwatch_home"]}/bin/checklb_service_#{zone} >> #{node[:nagios][:dir]}/#{node[:nagios][:config_subdir]}/services.cfg"
  action :run
  not_if "less /etc/nagios3/conf.d/services.cfg |grep _#{zone}"
end


end

Chef::Log.info("restart nagios...........")

execute "restart nagios" do
 
  user "root"
  command "sudo /etc/init.d/nagios3 restart"
  action :run
end


