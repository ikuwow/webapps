#
# Cookbook Name:: owncloud
# Recipe:: php
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

include_recipe "webapps::defualt"
include_recipe "webapps::php"

bash "Fetch owncloud" do
    code <<-EOC
    wget https://download.owncloud.org/community/owncloud-8.1.0.tar.bz2 owncloud.tar.bz2
    tar Ixvf owncloud.tar.bz2
    chmod -R apache:apache owncloud/
    EOC
    cwd "/var/www/html"
    creates "/var/www/html/owncloud"
end

