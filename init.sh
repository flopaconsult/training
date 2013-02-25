knife data bag create local_users
knife data bag from file local_users fdrescher.json

knife data bag create users
knife data bag from file users fdrescher.json
knife data bag from file users icingaadmin.json

knife data bag create aws
#knife data bag from file aws puravit.json
knife data bag from file aws main.json

knife data bag create git
knife data bag from file git github.json

knife data bag create chef
knife data bag from file chef chef-workspace.json

knife data bag create ssh
knife data bag from file ssh id_rsa_amazon.json

knife data bag create groups
knife data bag from file groups icingaadmin.json
knife data bag from file groups monadmin.json

knife role from file dev.rb
knife role from file magento.rb
knife role from file magento-webonly.rb
knife role from file monitoring.rb
knife role from file monitoring2.rb
knife role from file florindev.rb
knife role from file chef-workspace.rb
knife role from file maintenance-page.rb
knife role from file maintenance-page-check-load.rb
knife role from file maintenance-page-switch-on.rb
knife role from file maintenance-page-switch-off.rb
knife role from file maintenance-page-restart-webserver.rb
knife role from file chef-workspace-jenkins-ssh.rb
