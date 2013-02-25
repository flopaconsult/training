name "maintenance-page"
description "maintenance page magento e-commerce server"
run_list(
"recipe[apt]",
"recipe[aws]",
"recipe[chef_handler]",
"recipe[chef_handler_notifier]",
"recipe[apache2::default]",
"recipe[nagios::client]",
"recipe[maintenance_page::default]",
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
