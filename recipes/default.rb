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
include_recipe 'jetty::default'

# set up variables
service_env = "#{node[:nucleusproxy][:environment]}"

to_email = "#{node[:nucleusproxy][:god][:notification][:to]}"
from_email = "#{node[:nucleusproxy][:god][:notification][:from]}"
server_domain = "#{node[:nucleusproxy][:email][:domain]}"

tunnel_server_host = "#{node[:nucleusproxy][:smtp][:tunnel][:host]}"
tunnel_server_port = "#{node[:nucleusproxy][:smtp][:tunnel][:port]}"

smtp_server_host = "#{node[:nucleusproxy][:smtp][:host]}"
smtp_server_port = "#{node[:nucleusproxy][:smtp][:port]}"
smtp_user = "#{node[:nucleusproxy][:smtp][:user]}"
smtp_password = "#{node[:nucleusproxy][:smtp][:password]}"

apt_package "build-essential" do
	action :install
end

gem_package "god" do
	action :install
end

apt_package "stunnel4" do
	action :install
end

template "#{node[:jetty][:homedir]}/start.ini" do
	source "start.ini.erb"
	owner node[:jetty][:user]
	group node[:jetty][:group]
	variables({
		:environment => node[:nucleusproxy][:environment]
	})
	notifies :restart, "service[jetty]", :delayed
end

s3_file "#{node[:jetty][:webappsdir]}/#{node[:nucleusproxy][:localwar]}" do
	remote_path "#{node[:nucleusproxy][:source][:s3][:fullpath]}"
	#remote_path "tnt-nucleus/integration/1-22-3/tnt-nucleus-1.22.3.war"
	bucket "#{node[:nucleusproxy][:source][:s3][:bucket]}"
	if node[:nucleusproxy][:access_key_id]
		aws_access_key_id node[:nucleusproxy][:access_key_id]
		aws_secret_access_key node[:nucleusproxy][:access_key_secret]
	end
	action :create
	owner node[:jetty][:user]
	group node[:jetty][:group]
end

template "/etc/stunnel/stunnel.conf" do
	source "stunnel.conf.erb"

	owner node[:jetty][:user]
	group node[:jetty][:group]

	variables({
		:tunnel_server_port => tunnel_server_port,
		:smtp_server_host => smtp_server_host,
		:smtp_server_port => smtp_server_port
	})

	notifies :run, "execute[stunnel]"
end

execute "stunnel" do
	user "root"
	command "stunnel4 /etc/stunnel/stunnel.conf"
	action :nothing
end

directory "#{node[:nucleusproxy][:god][:goddir]}" do
	action :create
end

directory "#{node[:nucleusproxy][:god][:conditionsdir]}" do
	action :create
end

cookbook_file "#{node[:nucleusproxy][:god][:conditionsdir]}/JvmHeapUsage.rb" do
	source "JvmHeapUsage.rb"
	owner node[:jetty][:user]
	group node[:jetty][:group]
end

template "#{node[:nucleusproxy][:god][:goddir]}/jvm_heap_usage.god.rb" do
	source "jvm_heap_usage.god.rb.erb"
	owner node[:jetty][:user]
	group node[:jetty][:group]

	variables({
		:service_env => service_env,
		:to_email => to_email,
		:from_email => from_email,
		:server_domain => server_domain,
		:tunnel_server_host => tunnel_server_host,
		:tunnel_server_port => tunnel_server_port,
		:server_user => smtp_user,
		:server_password => smtp_password
	})

	notifies :run, "execute[start-god]", :delayed
end

execute "start-god" do
	user "root"
	command "god -c #{node[:nucleusproxy][:god][:goddir]}/jvm_heap_usage.god.rb"
	action :nothing
end