require 'rubygems'
require 'pony'

if node.has_key?("maintenance") && node.maintenance.has_key?("manually_switched_on") && node.maintenance.manually_switched_on == "false"

include_recipe "cloudwatch::default"

 
 e = execute "check_latency_elb" do
  ignore_failure true
    command "/home/ubuntu/latency_elb.sh #{node['latency']['back_in_time_minutes']} 60 us-east-1e >/home/ubuntu/latency_elb.txt"
    action :nothing
  end
 e.run_action(:run) 
  

 e = execute "single_value_column" do
  ignore_failure true
    command "awk </home/ubuntu/latency_elb.txt '{print $3}' >/home/ubuntu/single_column.txt"
    action :nothing
  end
 e.run_action(:run) 

# ruby_block "check_load_block" do
#  block do
   


counter = 1
lineAsNumeric = ""
  begin
      file = File.new("/home/ubuntu/single_column.txt", "r")
      while (line = file.gets)
          puts "Parsing file single_column.txt, counter: #{counter}, line: #{line}"
          counter = counter + 1
          lineAsNumeric = line
      end
      file.close
  rescue => err
      puts "Exception raised while parsing single_column.txt file: #{err}"
      err
  end
  if lineAsNumeric != ""
    if lineAsNumeric.to_f > node['load']['response_time_seconds']
        log "Expected response time has been exceeded ..."
        node.set['maintenance']['automatically_switched_on']="true"
        include_recipe "maintenance_page::switch_maintenance_on"




        Pony.mail({
          :to => node['pony']['mail']['to'],
          :from => node['pony']['mail']['from'],
          :via => :smtp,
          :subject => node['pony']['mail']['subject']['switch_on'], 
          :html_body => node['pony']['mail']['body']['switch_on'],
          :via_options => {
          :address              => node['pony']['mail']['smtp_server'],
          :port                 => node['pony']['mail']['smtp_port']=,
          :enable_starttls_auto => true,
          :user_name            => node['pony']['mail']['smtp_username'],
          :password             => node['pony']['mail']['smtp_password'],
          :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
          :domain               => node['pony']['mail']['domain'] # the HELO domain provided by the client to the server
          }
        })

    else
      # response time is not exceeded, maintenance page is switched off in case it was before automatically swtiched on
      if node.has_key?("maintenance") && node.maintenance.has_key?("automatically_switched_on") && node.maintenance.automatically_switched_on == "true"
      include_recipe "maintenance_page::switch_maintenance_off"
      node.set['maintenance']['automatically_switched_on']="false"
      end      
      
    end
end
  log "Current response time is : " + lineAsNumeric 

else
  log "Maintenance page is already switched on manually..." 
end