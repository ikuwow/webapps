#
# Cookbook Name:: webapps
# Recipe:: php
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'webapps::default'
include_recipe 'build-essential::default'

case node['platform']
when 'rhel', 'centos'
    devel_package = 'httpd-devel'
when 'ubuntu'
    devel_package = 'apache2-dev'
when 'debian'
    devel_package = 'apache2-prefork-dev'
else
    raise NotImplementedError
end

package devel_package

package "php php-common" do
    action :remove
end

php_version = "5.6.7"
build_option = '--prefix=/usr/local \
--with-apxs2 \
--enable-xml \
--with-config-file-path=/etc \
--enable-mbstring \
--with-mcrypt \
--with-openssl \
--with-curl \
--with-gd \
--with-jpeg-dir=/usr \
--with-vpx-dir=/usr \
--with-mysql \
--with-pdo-mysql \
--with-snmp \
--with-zlib'

check_uptodate = <<-EOC
test `php -v | grep #{php_version}` > /dev/null -a `php -i | grep configure | sed -e "s/'//g" | cut -d ' ' -f7-`" = "#{build_option}"
EOC

bash "Fetch PHP" do
    cwd "/tmp"
    code <<-EOC
    wget http://jp2.php.net/distributions/php-#{php_version}.tar.gz
    tar xvf php-#{php_version}.tar.gz
    EOC
    not_if { File.exists?("/tmp/php-#{php_version}") }
end

