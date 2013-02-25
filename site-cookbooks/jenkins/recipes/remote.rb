#
# Cookbook Name:: jenkins
# Based on hudson
# Recipe:: node_ssh
#
# Author:: Doug MacEachern <dougm@vmware.com>
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2010, VMware, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.set[:jenkins][:remote] = true

jenkins_server_nodes = search(:node, "jenkins_server_server:true AND app_environment:#{node[:app_environment]}")
if jenkins_server_nodes.empty?
  Chef::Log.warn("No jenkins server returned from search. Please start jenkins server first.")
  node.set[:jenkins][:server][:host] = ""
  node.set[:jenkins][:server][:pubkey] = ""
else
  jenkins_server_node = jenkins_server_nodes.first
  node.set[:jenkins][:server][:host] = jenkins_server_node[:jenkins][:server][:host]
  node.set[:jenkins][:server][:pubkey] = jenkins_server_node[:jenkins][:server][:pubkey]
  Chef::Log.info("Jenkins server node is: #{jenkins_server_node[:ipaddress]}")
end

#group node[:jenkins][:node][:user] do
#end

#user node[:jenkins][:node][:user] do
#  comment "Jenkins CI node (ssh)"
#  gid node[:jenkins][:node][:user]
#  home node[:jenkins][:node][:home]
#  shell "/bin/sh"
#end

#directory node[:jenkins][:node][:home] do
#  action :create
#  owner node[:jenkins][:node][:user]
#  group node[:jenkins][:node][:user]
#end

#directory "#{node[:jenkins][:node][:home]}/.ssh" do
#  action :create
#  mode 0700
#  owner node[:jenkins][:node][:user]
#  group node[:jenkins][:node][:user]
#end

#file "#{node[:jenkins][:node][:home]}/.ssh/authorized_keys" do
#  action :create
#  mode 0600
#  owner node[:jenkins][:node][:user]
#  group node[:jenkins][:node][:user]
#  content node[:jenkins][:server][:pubkey]
#end

#directory "#{node[:jenkins][:node][:home]}/jenkins-scripts/" do
#  action :create
#  mode 0755
#  owner node[:jenkins][:node][:user]
#  group node[:jenkins][:node][:user]
#end

#node[:authorization][:sudo][:users] << node[:jenkins][:node][:user]
#node[:authorization][:sudo][:groups] << node[:jenkins][:node][:user]
#include_recipe "sudo"

