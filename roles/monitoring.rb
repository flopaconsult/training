name "monitoring"
recipes "recipe[nagios::server]",
"recipe[nagios::server_enable_windows_hosts]",
"recipe[aws::default]",
# start - below list of recipes are related to nagios plugin for cloud metrics
"recipe[boto::default]",
#"recipe[boto::nagios-ec2events]",
"recipe[elb::default]",
"recipe[cloudwatch::default]",
"recipe[cloudwatch::nagios-checklb]",
# end list of nagios plugins related to cloud metrics
"recipe[nagios::check_mysql_health]",
"recipe[jenkins::remote]"
	#"recipe[munin::server]"
override_attributes({
  "tz" => "America/Los_Angeles",
  "ec2tag" => {
    "name" => "monitoring"
  },
  "nagios" => {
#    "notifications_enabled" => "1"
    "server_auth_method" => "place-holder" #this will default to the default Apache authentification
  },
  "munin" => {
    "server_auth_method" => "place-holder" #this will default to the default Apache authentification
  },
  "apache" => {
    "listen_ports" => [ "80","81","82","83" ]
  },
  "mysql" => {
	   "mysql_user" => "monitoring",
	   "mysql_pwd" => "monitoring"
  }
})



