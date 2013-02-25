name "maintenance-page-check-load"
description "maintenance page magento e-commerce server: role for cheking load"
run_list(
"recipe[maintenance_page::check_load]",
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
