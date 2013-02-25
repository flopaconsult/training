name "monitoring2"
recipes "recipe[apt]",
	"recipe[icinga::server]",
        "recipe[icinga::check_mysql_health]",
	"recipe[icinga::icinga_configurations]"
override_attributes({
  "tz" => "America/Los_Angeles",
  "ec2tag" => {
    "name" => "mon2"
  },
  "check_mk" => {
    "groups" => ['monadmin']
  },
  "pnp4nagios" => {
    "htpasswd" => {
      "file" => "/etc/icinga/htpasswd.users"
    }
  }
})

