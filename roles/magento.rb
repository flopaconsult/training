name "magento"
description "magento e-commerce server"
run_list(
"recipe[apt]",
"recipe[mysql::server]",
"recipe[magento::php-multi]",
"recipe[magento]"
)
override_attributes(
  "ec2tag" => {
    "name" => "magento"
  },
  "mysql" => {
    "server_root_password" => "root"
  }
)
