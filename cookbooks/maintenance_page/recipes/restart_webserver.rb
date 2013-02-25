	service "apache2" do
  		action :restart
	end

	execute "refresh_web_server_after_restart" do
		command "wget http://#{node.ec2.local_ipv4}/#{node['elb']['site']['health_check_url']}"
		action :run
	end




