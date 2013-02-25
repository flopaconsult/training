maintainer       "YOUR_COMPANY_NAME"
maintainer_email "YOUR_EMAIL"
license          "All rights reserved"
description      "Installs/Configures elb"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.2"



%w{ ark java }.each do |cookbook|
  depends cookbook
end

