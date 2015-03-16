#
# Cookbook Name:: webapps
# Recipe:: default
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

web_user = "apache"
web_group = "apache"

node.default['apache']['user'] = web_user
node.default['apache']['group'] = web_group

group web_group do
    system true
    action :create
end

user "Web user" do
    username web_user
    gid web_group
    shell '/dev/null'
    system true
    action :create
end

include_recipe 'apache2'

directory "/var/www/html" do
    user web_user
    group web_group
    mode 0755
    action :create
end

package "git" do
    action :install
end


