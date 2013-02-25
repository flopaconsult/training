# package "openjdk-6-jdk"
include_recipe "java::default"

include_recipe "ark"


 ark "#{node["elb"]["elb_version_name"]}" do
   path node["elb"]["scripts_home"]
   url 'http://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip'
   checksum '89ba5fde0c596db388c3bbd265b63007a9cc3df3a8e6d79a46780c1a39408cb5'
   action :put
 end


template "#{node["elb"]["aws_elb_home"]}/bin/credentials.txt" do
  source "credentials.txt" 
  mode "0644"
end


