maintainer       "YOUR_COMPANY_NAME"
maintainer_email "YOUR_EMAIL"
license          "All rights reserved"
description      "Installs/Configures maintenance_page"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"



%w{ elb cloudwatch sudo apache2-maintenance }.each do |cookbook|
  depends cookbook
end

