#
# Cookbook Name:: webapps
# Recipe:: query_ok
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'webapps::default'
include_recipe 'apache2::mod_expires'

app_dir = "/var/www/html/query_ok"

git 'query_ok' do
    repository "https://github.com/ikuwow/query_ok.git"
    revision "old-on-testtube"
    checkout_branch "release"
    destination app_dir
    user node['apache']['user']
    group node['apache']['group']
    action :sync
end

web_app "query_ok" do
    docroot app_dir
    template 'web_app.conf.erb'
    cookbook 'webapps' # My Template! Not apache2 template.
    allow_override "All"
    server_name 'ikuwow.website'
end

