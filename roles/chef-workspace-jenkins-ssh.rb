name "chef-workspace-jenkins-ssh"
description "workspace environment"
run_list(
    "recipe[jenkins::update_ssh_sites]"
)
override_attributes(
  "ec2tag" => {
    "name" => "chef-workspace"
  }
)
