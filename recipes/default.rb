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
include_recipe 'jetty::logback'

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

apt_package "god" do
	action :install
end

directory "#{node[:nucleusproxy][:god][:goddir]}" do
	action :create
end

directory "#{node[:nucleusproxy][:god][:conditionsdir]}" do
	action :create
end

execute "start-god" do
	command "god -c #{node[:nucleusproxy][:god][:goddir]}/jvm_heap_usage.god.erb"
end

template "#{node[:nucleusproxy][:god][:conditionsdir]}/JvmHeapUsage.rb" do
	source "JvmHeapUsage.rb"
	owner node[:jetty][:user]
	group node[:jetty][:group]
end

template "#{node[:nucleusproxy][:god][:conditionsdir]}/ServiceJettyAvailability.rb" do
	source "ServiceJettyAvailability.rb"
	owner node[:jetty][:user]
	group node[:jetty][:group]
end

template "#{node[:nucleusproxy][:god][:goddir]}/jvm_heap_usage.god.erb" do
	source "jvm_heap_usage.god.erb"
	owner node[:jetty][:user]
	group node[:jetty][:group]

	notifies :run, "execute[start-god]", :delayed
end