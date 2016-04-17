#
# Cookbook Name:: webapps
# Recipe:: ruby
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

case node['platform']
when 'centos', 'redhat'
    %w{wget gcc libyaml-devel gdbm openssl openssl-devel tk
        zlib zlib-devel sqlite sqlite-devel libxml2-devel libxslt-devel libcurl-devel httpd-devel apr-devel apr-util-devel libffi libffi-devel readline readline-devel}.each do |pkg|
        package "Install #{pkg} for ruby" do
            package_name pkg
            action :install
        end
    end
when 'debian','ubuntu'
    %w{gcc}.each do |p|
        package "Install #{p} for ruby" do
            package_name p
            action :install
        end
    end
end


ruby_version = '2.2.2'

bash "install_ruby" do
    code <<-EOC
    cd /tmp
    wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-#{ruby_version}.tar.gz
    tar xvf ruby-#{ruby_version}.tar.gz
    cd ruby-#{ruby_version}
    ./configure --disable-install-rdoc --enable-shared --prefix=/usr
    make
    make install
    EOC
    not_if "ruby -v | grep #{ruby_version}"
end

