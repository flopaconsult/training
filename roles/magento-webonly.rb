name "magento-webonly"
description "magento e-commerce server"
run_list(
"recipe[apt]",
"recipe[aws]",
"recipe[chef_handler]",
"recipe[chef_handler_notifier]",
"recipe[elb::default]",
"recipe[elb::reg_unreg_tofrom_elb]",
"recipe[mysql::client]",
"recipe[magento::php-multi]",
"recipe[magento::webonly]",
"recipe[apache2-munin::magento-munin]",
"recipe[nagios::client]",
"recipe[jenkins::remote]"
)
override_attributes(
  "ec2tag" => {
    "name" => "magento"
  },
  "mysql" => {
    "server_root_password" => "root"
  },
  "nagios" => {
    "server_role" => "monitoring"
  }
)
