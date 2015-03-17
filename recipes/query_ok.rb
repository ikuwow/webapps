#
# Cookbook Name:: webapps
# Recipe:: query_ok
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'webapps::default'

deploy 'query_ok' do
    repo "git@github.com:ikuwow/query_ok.git" 
    revision "master"
    deploy_to "/var/www/html/query_ok"
    user node['apache']['user']
    group node['apache']['group']
    action :deploy
end

web_app "query_ok" do
    docroot '/var/www/html/query_ok'
    template 'web_app.conf.erb'
    cookbook 'apache2'
    server_name 'ikuwow.website'
end

