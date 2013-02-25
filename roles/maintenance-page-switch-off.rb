name "maintenance-page-switch-off"
description "maintenance page magento e-commerce server: role for switch off"
run_list(
"recipe[maintenance_page::switch_maintenance_off]",
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
