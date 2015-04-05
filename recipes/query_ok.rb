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
    checkout_branch "release"
    destination app_dir
    user node['apache']['user']
    group node['apache']['group']
    action :sync
end

ed = {
    '404' => '/error/404/index.html',
    '403' => '/error/403/index.html'
}

web_app "query_ok" do
    docroot app_dir
    template 'web_app.conf.erb'
    cookbook 'webapps' # My Template! Not apache2 template.
    error_documents ed
    server_name 'ikuwow.website'
end

