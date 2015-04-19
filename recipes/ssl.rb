#
# Cookbook Name:: webapps
# Recipe:: ssl
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'webapps::default'

include_recipe 'apache2::mod_ssl'

directory "#{node['apache']['dir']}/keys" do
    owner "root"
    group "root"
    action :create
end

ssl_certificates = Chef::EncryptedDataBagItem.load('apache','ssl_certificates')

{
    "certificate" => "#{node['apache']['dir']}/keys/wildcard.ikuwow.com.crt",
    "key" => "#{node['apache']['dir']}/keys/wildcard.ikuwow.com.key"
}.each do |name,path|
    file path do
        owner 'root'
        group 'root'
        mode '0644'
        content ssl_certificates[name]
        action :create
    end
end
