name "maintenance-page-restart-webserver"
description "maintenance page magento e-commerce server: role for restart webserver"
run_list(
"recipe[maintenance_page::restart_webserver]",
"recipe[jenkins::remote]"
)
override_attributes(
  "ec2tag" => {
    "name" => "maintenance-page"
  },
  "mysql" => {
    "server_root_password" => "root"
  },
  "nagios" => {
    "server_role" => "monitoring"
  }
)
