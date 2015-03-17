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

group "Web group" do
    group_name web_group
    system false
    action :create
end

user "Web user" do
    username web_user
    gid web_group
    home '/home/apache'
    shell '/bin/bash'
    system false
    action :create
end

directory "/home/#{web_user}/.ssh/" do
    user web_user
    group web_group
    recursive true
    mode 0700
    action :create
end

ssh_keys = Chef::EncryptedDataBagItem.load("apache","ssh_keys");

file "/home/#{web_user}/.ssh/id_rsa" do
    content ssh_keys["private"]
    user web_user
    group web_user
    mode 0600
    action :create
end

file "/home/#{web_user}/.ssh/id_rsa.pub" do
    content ssh_keys["public"]
    user web_user
    group web_user
    mode 0600
    action :create
end

# install and configure apache2
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


