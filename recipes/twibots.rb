#
# Cookbook Name:: webapps
# Recipe:: twibots
#
# Copyright 2015, ikuwow
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'webapps::ssl'

app_dir = "/var/www/html/twibots"

deploy "twibots" do
    repo "git@github.com:ikuwow/twibots.git"
    user "apache"
    group "apache"
    deploy_to app_dir
    # migrate true
    # migration_command "composer update"
end

