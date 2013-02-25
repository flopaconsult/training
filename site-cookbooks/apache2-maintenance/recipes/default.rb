template "#{node['apache']['dir']}/sites-available/default" do
  source "default-site.erb"
  owner "root"
  group node['apache']['root_group']
  mode 00644
  notifies :restart, "service[apache2]"
end

%w{ mod_proxy mod_rewrite }.each do |mod|
  module_recipe_name = mod =~ /^mod_/ ? mod : "mod_#{mod}"
  include_recipe "apache2::#{module_recipe_name}"
end

apache_site "default" do
  enable !!node['apache']['default_site_enabled']
end

service "apache2" do
  action :start
end
