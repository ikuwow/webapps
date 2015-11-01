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
    repository "https://github.com/ikuwow/ikuwow_top.git"
    revision "master"
    checkout_branch "release"
    destination app_dir
    user node['apache']['user']
    group node['apache']['group']
    action :sync
end

web_app "ikuwow_top" do
    docroot app_dir
    allow_override "All"
    template 'web_app.conf.erb'
    cookbook 'webapps'
    server_name 'www.ikuwow.com'
end

web_app "ikuwow_top_ssl" do
    docroot app_dir
    allow_override "All"
    is_ssl true
    template 'web_app.conf.erb'
    cookbook 'webapps'
    server_name 'www.ikuwow.com'
    server_port 443
end

web_app "blog.ikuwow.com" do
    docroot app_dir
    allow_override "All"
    template 'web_app.conf.erb'
    cookbook 'webapps'
    server_name 'blog.ikuwow.com'
    server_port 80
end

web_app "ssl_blog.ikuwow.com" do
    docroot app_dir
    allow_override "All"
    is_ssl true
    template 'web_app.conf.erb'
    cookbook 'webapps'
    server_name 'blog.ikuwow.com'
    server_port 443
end


