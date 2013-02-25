name "mysql_slave"
description "mysql slave"
run_list(
"recipe[apt]",
"recipe[mysql::db_server]"
#"recipe[mysql-munin::munin]" #TODO, fix the download link
)
override_attributes(
  "ec2tag" => {
    "name" => "mysql-slave"
  },
  "mysql" => {
    "server_root_password" => "root",
    "server_type" => "slave"
  }
)
