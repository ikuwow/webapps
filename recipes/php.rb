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
when 'debian', 'ubuntu'
    bash "aptitude update && aptitude upgrade -y" do
        code "aptitude update && aptitude upgrade -y"
        action :run
    end
    devel_package = 'apache2-prefork-dev'
else
    raise NotImplementedError
end

package devel_package

package "php php-common" do
    action :remove
end

# Dependent packages
case node['platform']
when 'centos'

    apache_service_name = "httpd"

    dep_packages = %w{
        libxml2 libxml2-devel libpng libpng-devel libjpeg libjpeg-devel
        libvpx libvpx-devel openssl openssl-devel libcurl libcurl-devel
    }

    # add epel repository to yum
    bash 'add_epel' do
        user 'root'
        code <<-EOC
            rpm -ivh http://ftp.riken.jp/Linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
            sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/epel.repo
        EOC
        creates "/etc/yum.repos.d/epel.repo"
        not_if { File.exists?("/etc/yum.repos.d/epel.repo") }
    end

    %w{libmcrypt libmcrypt-devel}.each do |p|
        package "Install #{p} for PHP" do
            package_name p
            options "--enablerepo=epel"
            action :install
        end
    end

when 'debian'

    apache_service_name = "apache2"

    dep_packages = %w{
        pkg-config libxml2 libxml2-dev libssl-dev libcurl4-openssl-dev libvpx1 libvpx-dev
        libpng12-dev libmcrypt4 libmcrypt-dev
        libjpeg-dev
    }
        # libjpeg8 libjpeg8-dev

when 'ubuntu'

    apache_service_name = "apache2"

    dep_packages = %w{
        pkg-config libxml2 libxml2-dev libcurl4-openssl-dev libvpx1 libvpx-dev
        libpng12-dev libmcrypt4 libmcrypt-dev
        libjpeg8 libjpeg8-dev
    }

else
    raise NotImplementedError
end

dep_packages.each do |p|
    package "Install #{p} for PHP" do
        package_name p
        action :install
    end
end



php_version = "5.6.7"
if node['platform'] == 'debian'
    apxs_path = "=/usr/bin/apxs2"
else
    apxs_path = ""
end
build_option = "--prefix=/usr/local \
--enable-mbstring \
--enable-xml \
--enable-zip \
--with-apxs2#{apxs_path} \
--with-config-file-path=/etc \
--with-mcrypt \
--with-openssl \
--with-curl \
--with-gd \
--with-jpeg-dir=/usr \
--with-vpx-dir=/usr \
--with-mysql \
--with-mysqli \
--with-pdo-mysql \
--with-zlib"

check_uptodate = <<-EOC
test `/usr/local/bin/php -v | grep #{php_version} > /dev/null;echo $?` -eq 0 -a "`/usr/local/bin/php -i | grep configure | sed -e "s/'//g" | cut -d ' ' -f7-`" = "#{build_option}"
EOC

bash "Fetch PHP" do
    cwd "/tmp"
    code <<-EOC
    wget http://jp2.php.net/distributions/php-#{php_version}.tar.gz
    tar xvf php-#{php_version}.tar.gz
    EOC
    not_if { File.exists?("/tmp/php-#{php_version}") } || check_uptodate
end

# ubuntu is not implemented..
if node['platform'] != 'ubuntu'

    bash "Build PHP" do
        cwd "/tmp/php-#{php_version}"
        code "./configure #{build_option}  && make clean && make && make install | tee ./php-build.log"
        not_if check_uptodate
        notifies :run, "bash[Restart Apache to apply PHP changes]"
    end
    
    bash "Restart Apache to apply PHP changes" do
        code "service #{apache_service_name} graceful"
        action :nothing
    end

    # php config
    template "#{node['apache']['dir']}/mods-available/php.conf" do
        source "php.conf.erb"
        owner "root"
        group "root"
        action :create
    end

    link "#{node['apache']['dir']}/mods-enabled/php.conf" do
        owner "root"
        group "root"
        to "../mods-available/php.conf"
        action :create
    end

    package "curl" do
        action :install
    end

    bash "Install Composer" do
        cwd "/tmp"
        code <<-EOC
        curl -sS https://getcomposer.org/installer | php
        mv composer.phar /usr/local/bin/composer
        EOC
        creates "/usr/local/bin/composer"
    end

end

