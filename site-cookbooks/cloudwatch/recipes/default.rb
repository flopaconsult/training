package "openjdk-6-jdk"

directory "/opt/cloudwatch" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

execute "download cloudwatch tools" do
  cwd "/opt/cloudwatch"
  user "root"
  command "wget http://ec2-downloads.s3.amazonaws.com/CloudWatch-2010-08-01.zip"
  action :run
end

package "unzip" do
  action :install
end

execute "Unzip cloudwatch tools" do
  cwd "/opt/cloudwatch"
  user "root"
  command "unzip -o -q CloudWatch-2010-08-01.zip"
  action :run
end

template "#{node['cloudwatch']['aws_cloudwatch_home']}/bin/credentials.txt" do
  source "credentials.txt" 
  mode "0700"
end

template "#{node['cloudwatch']['aws_cloudwatch_home']}/bin/lbnagioscheck.sh" do
  source "lbnagioscheck.erb"
  mode 0700
  
end


template "#{node['cloudwatch']['aws_cloudwatch_home']}/bin/checklb" do
  source "checklb.erb"
  mode 0700
  
end

execute "change_permission_cloud_bin" do
  user "root"
  command "sudo chmod \"a+r\" #{node['cloudwatch']['aws_cloudwatch_home']}/bin/*.*"
  action :run
end

execute "change_permission_cloud_checklb" do
  user "root"
  command "sudo chmod \"a+rx\" #{node['cloudwatch']['aws_cloudwatch_home']}/bin/checklb"
  action :run
end

execute "change_permission_cloud_lbnagioscheck" do
  user "root"
  command "sudo chmod \"a+rx\" #{node['cloudwatch']['aws_cloudwatch_home']}/bin/lbnagioscheck.sh"
  action :run
end




