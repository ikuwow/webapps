#
# Cookbook Name:: webapps
# Recipe:: rails
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'webapps::ssl'
include_recipe 'webapps::ruby'

bash "install_rails" do
	code <<-EOC
	gem install nokogiri -- --use-system-libraries
	gem install --no-ri --no-rdoc rails
	gem install --no-ri --no-rdoc sqlite3
	EOC
	not_if "which rails"
end

bash "install_passenger" do
	code <<-EOC
	gem install --no-ri --no-rdoc passenger
	passenger-install-apache2-module --auto
	EOC
	not_if "which passenger"
end
