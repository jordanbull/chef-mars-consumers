#
# Cookbook Name:: nucleus
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'java'

remote_file "#{Chef::Config[:file_cache_path]}/jetty-deb-8.1.9.v20130131.deb" do
	source "http://central.maven.org/maven2/org/mortbay/jetty/dist/jetty-deb/8.1.9.v20130131/jetty-deb-8.1.9.v20130131.deb"
	action :create
end

dpkg_package "jetty-hightide-server" do
	source "#{Chef::Config[:file_cache_path]}/jetty-deb-8.1.9.v20130131.deb"
	action :install
end

execute "remove jetty contexts" do
	command "rm -rf /opt/jetty/contexts/*"
end

execute "remove jetty webapps" do
	command "rm -rf /opt/jetty/webapps/*"
end

#s3_file "#{Chef::Config[:file_cache_path]}/tnt-nucleus-1.22.3.war" do



s3_file "/opt/jetty/webapps/root.war" do
	remote_path "tnt-nucleus/integration/1-22-3/tnt-nucleus-1.22.3.war"
	bucket "tnt-build-release"
	if node[:nucleus][:access_key_id]
		aws_access_key_id node[:nucleus][:access_key_id]
		aws_secret_access_key node[:nucleus][:access_key_secret]
	end
	action :create
	owner "vagrant"
	group "vagrant"
end

template "/opt/jetty/etc/jetty.xml" do
	source "jetty.xml.erb"
	owner "vagrant"
	group "vagrant"
end

template "opt/jetty/etc/jetty-logging.xml" do
	source "jetty-logging.xml.erb"
	owner "vagrant"
	group "vagrant"
end

service "jetty" do
	action :restart
end