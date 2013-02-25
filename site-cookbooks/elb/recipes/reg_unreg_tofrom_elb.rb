template "#{node["elb"]["scripts_home"]}/elb_register.sh" do
  source "elb_register.erb"
  mode 0644
  variables(
    :ec2_instance_node_name => "#{node[:ec2][:instance_id]}",
    :elbs => node["elb"]["names"]
  )
end



bash "backup_original_etc_rc_local" do
	code <<-EOH
	cp /etc/rc.local /etc/rc.local_original
	EOH
	not_if "test -f /etc/rc.local_original"
end



bash "change_etc_rc_local" do
  
  code <<-EOH
	sed '$d' < /etc/rc.local_original > /etc/rc.local_temp
	mv /etc/rc.local /etc/rc.local_old
	mv /etc/rc.local_temp /etc/rc.local

	cat #{node["elb"]["scripts_home"]}/elb_register.sh >> /etc/rc.local
	echo exit 0 >> /etc/rc.local
  EOH
end

execute "change_permission_rc_local" do
  user "root"
  command "chmod \"a+rwx\" /etc/rc.local"
  action :run
end

execute "Starts ELB" do
  user "root"
  command "/etc/rc.local"
  action :run
end

template "/etc/init.d/K99elb_deregister.sh" do
  source "elb_deregister.erb"
  mode 0644
  variables(
    :ec2_instance_node_name => "#{node[:ec2][:instance_id]}",
    :elbs => node["elb"]["names"]
  )
end

execute "change_permission_deregister" do
  user "root"
  command "chmod \"a+rwx\" /etc/init.d/K99elb_deregister.sh"
  action :run
end

# ln -s /etc/init.d/K99elb_deregister.sh /etc/rc0.d/K99elb_deregister.sh
link "/etc/rc0.d/K99elb_deregister.sh" do
  to "/etc/init.d/K99elb_deregister.sh"
end

# ln -s /etc/init.d/K99elb_deregister.sh /etc/rc6.d/K99elb_deregister.sh
link "/etc/rc6.d/K99elb_deregister.sh" do
  to "/etc/init.d/K99elb_deregister.sh"
end
