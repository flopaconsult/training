name "maintenance-page-switch-on"
description "maintenance page magento e-commerce server: role for switch on"
run_list(
"recipe[maintenance_page::switch_maintenance_on]",
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
