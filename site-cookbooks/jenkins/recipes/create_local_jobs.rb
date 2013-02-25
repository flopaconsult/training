pid_file = "/var/run/jenkins/jenkins.pid"

ruby_block "block_until_operational" do
  block do
    Chef::Log.info "Waiting for Jenkins server to start..."
    until IO.popen("netstat -lnt").entries.select { |entry|
        entry.split[3] =~ /:#{node[:jenkins][:server][:port]}$/
      }.size == 1
      Chef::Log.info "service[jenkins] not listening on port #{node.jenkins.server.port}"
      sleep 5
    end

    loop do
      url = URI.parse("#{node.jenkins.server.url}/job/test/config.xml")
      res = Chef::REST::RESTRequest.new(:GET, url, nil).call
      break if res.kind_of?(Net::HTTPSuccess) or res.kind_of?(Net::HTTPNotFound)
      Chef::Log.debug "service[jenkins] not responding OK to GET / #{res.inspect}"
      sleep 5
    end
    Chef::Log.info "Jenkins server is operational."
  end
  action :nothing
end

ruby_block "netstat2" do
  block do
    100.times do
      if IO.popen("netstat -lnt").entries.select { |entry|
          entry.split[3] =~ /:#{node[:jenkins][:server][:port]}$/
        }.size == 0
        break
      end
      Chef::Log.info("service[jenkins] still listening (port #{node[:jenkins][:server][:port]})")
      sleep 3
    end
  end
  action :nothing
end

service "jenkins" do
  service_name "jenkins"
  supports [ :stop, :start, :restart, :status, :reload ]
  status_command "test -f #{pid_file} && kill -0 `cat #{pid_file}`"
  reload_command "sudo /etc/init.d/jenkins force-reload"
  action :nothing
end


################## GIT checkout job #######################
job_config = File.join(node[:jenkins][:server][:home], "#{node[:jenkins][:job_name_checkout]}-config.xml")
job_name = node[:jenkins][:job_name_checkout]


template "#{node[:jenkins][:server][:scripts_dir]}/git_checkout.sh" do
  source "git_checkout.sh.erb"
  mode 0700
  owner node[:jenkins][:server][:user]
  group node[:jenkins][:server][:group]
  variables :job_name => node[:jenkins][:job_name_checkout]
end

jenkins_job job_name do
  action :nothing
  config job_config
end
  
template job_config do
  source "job_config_GIT_checkout.xml.erb"
  owner node[:jenkins][:server][:user]
  group node[:jenkins][:server][:group]
  variables :job_name => node[:jenkins][:job_name_checkout]
  notifies :update, resources(:jenkins_job => job_name), :immediately
end

file job_config do
  action :delete
  backup false
end



################## Start instances job #######################
job_name = "Start-New-Instances"
job_config = File.join(node[:jenkins][:server][:home], "#{job_name}-config.xml")

template "#{node[:jenkins][:server][:scripts_dir]}/start_instances.sh" do
  source "start_instances.sh.erb"
  mode 0700
  owner node[:jenkins][:server][:user]
  group node[:jenkins][:server][:group]
  variables :job_name => job_name
end

jenkins_job job_name do
  action :nothing
  config job_config
end
  
template job_config do
  source "job_config_start_instances.xml.erb"
  owner node[:jenkins][:server][:user]
  group node[:jenkins][:server][:group]
  variables :job_name => job_name
  notifies :update, resources(:jenkins_job => job_name), :immediately
end

file job_config do
  action :delete
  backup false
end


################## SSH Sites discoverer job #######################
job_name2 = "SSH-sites-discovery"
job_config2 = File.join(node[:jenkins][:server][:home], "#{job_name2}-config.xml")

jenkins_job job_name2 do
  action :nothing
  config job_config2
end

template job_config2 do
  source "job_config_SSH_sites_discoverer.xml.erb"
  owner node[:jenkins][:server][:user]
  group node[:jenkins][:server][:group]
  variables :job_name => job_name2
  notifies :update, resources(:jenkins_job => job_name2), :immediately
end

file job_config2 do
  action :delete
  backup false
end

################## Reload jenkins config job #######################
job_name3 = "local-job-JENKINS-main-config-reload"
job_config3 = File.join(node[:jenkins][:server][:home], "#{job_name3}-config.xml")

jenkins_job job_name3 do
  action :nothing
  config job_config3
end

template job_config3 do
  source "job_config_LOCAL_jenkins_reload_configs.xml.erb"
  owner node[:jenkins][:server][:user]
  group node[:jenkins][:server][:group]
  variables :job_name => job_name3
  notifies :update, resources(:jenkins_job => job_name3), :immediately
end

file job_config3 do
  action :delete
  backup false
end

################## SSH discoverer jobs ##############
include_recipe "jenkins::update_ssh_sites"

log "Restart jenkins again for reloading config" do  
  notifies :restart, "service[jenkins]", :delayed
  notifies :create, "ruby_block[block_until_operational]", :delayed
end