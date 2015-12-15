#
# Cookbook Name:: webapps
# Recipe:: api_ikuwow
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'webapps::ssl'
include_recipe 'webapps::php'

app_dir = '/var/www/html/api'

git 'api_ikuwow' do
    repository "https://github.com/ikuwow/api.ikuwow.com.git"
    revision "master"
    checkout_branch "release"
    destination app_dir
    user node['apache']['user']
    group node['apache']['group']
    action :sync
end


web_app "api_ikuwow" do
    docroot app_dir
    allow_override "All"
    is_ssl false
    template 'web_app.conf.erb'
    cookbook 'webapps'
    server_name 'api.ikuwow.com'
    server_port 80
end

web_app "api_ikuwow" do
    docroot app_dir
    allow_override "All"
    is_ssl true
    template 'web_app.conf.erb'
    cookbook 'webapps'
    server_name 'api.ikuwow.com'
    server_port 443
end


