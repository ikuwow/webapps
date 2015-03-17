#
# Cookbook Name:: webapps
# Recipe:: query_ok
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'webapps::default'

app_dir = "/var/www/html/query_ok"

git 'query_ok' do
    repository "git@github.com:ikuwow/query_ok.git" 
    revision "master"
    checkout_branch "master"
    destination app_dir
    user node['apache']['user']
    group node['apache']['group']
    action :sync
end

web_app "query_ok" do
    docroot app_dir
    template 'web_app.conf.erb'
    cookbook 'apache2'
    server_name 'ikuwow.website'
end

