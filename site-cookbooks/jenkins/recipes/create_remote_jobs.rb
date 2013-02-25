#all_jenkins_ssh_nodes = search(:node, "role:#{node[:jenkins][:remote_ssh_role]} AND app_environment:#{node[:app_environment]}")
#all_jenkins_ssh_nodes = search(:node, "recipes:jenkins\\:\\:remote AND app_environment:#{node[:app_environment]}")
#
#ssh_sites_result = Array.new
#all_jenkins_ssh_nodes.each do |n|
#  if n.has_key?("jenkins") && n.jenkins.has_key?("elb")
#    server_fqdn = n.elb.dnsname
#  else
#    if n.has_key?("ec2")
#      if n.ec2.has_key?("public_hostname")
#        server_fqdn = n.ec2.public_hostname
#      else
#        server_fqdn = n.ipaddress #VPC
#      end
#    else
#      server_fqdn = n.fqdn
#    end
#  end
#  ssh_sites_result << server_fqdn
#end
#
#ssh_sites_result.each do |site|
#  jenkins_ssh_job "#{site}-chef-client" do
#    action :create
#    description "#{site}-chef-client"
#    job_name "#{site}-chef-client"
#    remote_host "#{site}"
#    config_template "ssh-job-config.xml.erb"
#    commands node[:ssh_commands][:all_servers]
#  end
#end










