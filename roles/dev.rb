name "dev"
description ""
recipes "recipe[ntp::default]",
  "recipe[ec2-tools::set-hostname]",
  "recipe[ec2-tools::set-tag]",
  "recipe[munin::client]",
  "recipe[nagios::client]"
override_attributes({
  "environment" => {
    "name" => "dev"
  },
  "app_environment" => "dev",
  "region" => "us-east-1",
  "ec2tag" => {
     "aws_access_key_id" => "AKIAIQIZ6SZQLOFEDMKA",
     "aws_secret_access_key" => "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",
     "ec2_region" => "http://us-east-1.ec2.amazonaws.com"
  },
  "mysql" => {
    "role" => "mysql_magento",             #allows the slave to find its master
    "snapshot_filter" => "dev-mysql-sdm",  #allows slave to find the latest snapshot
    "server_type" => "master",
    "databag_cred" => "main"
  }
})

