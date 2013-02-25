name "mysql_magento"
description "mysql server"
run_list(
"recipe[apt]",
"recipe[mysql::db_server]",
"recipe[magento::mysql_settings]",
"recipe[munin::mysql_settings]",
#"recipe[mysql-munin::munin]", #TODO, fix the download link
"recipe[nagios::client]",
#"recipe[nagios::mysql_nagios_check]",
"recipe[nagios::check_mysql_health]",
"recipe[jenkins::remote]"
)
override_attributes(
  "ec2tag" => {
    "name" => "mysql"
  },
  "mysql" => {
    "server_root_password" => "root",
    "server_repl_password" => "root",
    "server_type" => "master"
  },
  "magento" => {
    "mysql_user" => "magento",
    "mysql_pwd" => "magento"
  }
)
