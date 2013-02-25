name "chef-workspace"
description "workspace environment"
run_list(
"recipe[chef-workspace-impl]",
"recipe[jenkins::default]",
"recipe[jenkins::create_local_jobs]"
)
override_attributes(
  "ec2tag" => {
    "name" => "chef-workspace"
  }
)
