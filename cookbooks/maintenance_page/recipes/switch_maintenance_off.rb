
	execute "elb_deregister_ec2_from_elb" do
		command "#{node["elb"]["scripts_home"]}/elb_deregister_ec2_from_elb.sh #{node.ec2.instance_id}"
		action :run
	end

web_nodes = Array.new

search(:node,"#{node['maintenance_page']['webserver_search_expr']} AND app_environment:#{node[:app_environment]}") do |n|
  web_nodes << n
end

web_nodes.each do |web_node|
	log "Trying to register to ELB following instance:"
	log "#{web_node.ec2.instance_id}"
	
	execute "elb_register_ec2_to_elb" do
		command "#{node["elb"]["scripts_home"]}/elb_register_ec2_to_elb.sh #{web_node.ec2.instance_id}"
		action :run
	end
	



end

execute "elb_change_health_check" do
		command "#{node["elb"]["scripts_home"]}/elb_change_health_check.sh #{node['elb']['site']['health_check_url']} #{node['elb']['site']['health_check_interval']} #{node['elb']['site']['health_check_timeout']} #{node['elb']['site']['health_check_unhealthy_treshhold']} #{node['elb']['site']['health_check_healthy_treshhold']}"
		action :run
end
# I consider manually switched on ONLY if this code is not called from check_load.rb - which means that actually it was automatically switched on
if node.has_key?("maintenance") && node.maintenance.has_key?("automatically_switched_on") && node.maintenance.automatically_switched_on == "false"

node.set['maintenance']['manually_switched_on']="false"
end