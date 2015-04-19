#
# Cookbook Name:: webapps
# Recipe:: query_ok
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'webapps::ssl'

app_dir = "/var/www/html/ikuwow_top"

git 'query_ok' do
    repository "git@github.com:ikuwow/ikuwow_top.git" 
    revision "master"
    checkout_branch "release"
    destination app_dir
    user node['apache']['user']
    group node['apache']['group']
    action :sync
end

web_app "ikuwow_top" do
    docroot app_dir
    template 'web_app.conf.erb'
    cookbook 'webapps'
    server_name 'www.ikuwow.com'
end

web_app "ikuwow_top_ssl" do
    docroot app_dir
    is_ssl true
    template 'web_app.conf.erb'
    cookbook 'webapps'
    server_name 'www.ikuwow.com'
    server_port 443
end

