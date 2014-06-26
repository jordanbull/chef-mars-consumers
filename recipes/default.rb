#
# Cookbook Name:: mars
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
service_env = "#{node[:war][:environment]}"

apt_package "build-essential" do
	action :install
end

=begin
gem_package "god" do
	action :install
end
=end

template "#{node[:jetty][:homedir]}/start.ini" do
	source "start.ini.erb"
	owner node[:jetty][:user]
	group node[:jetty][:group]

	variables({
		:environment => node[:war][:environment],
		:properties_path => node[:mars][:properties]
	})

	notifies :restart, "service[jetty]", :delayed
end

s3_file "#{node[:jetty][:webappsdir]}/#{node[:war][:localwar]}" do
	remote_path "#{node[:war][:source][:s3][:fullpath]}"
	bucket "#{node[:war][:source][:s3][:bucket]}"

	if node[:war][:access_key_id]
		aws_access_key_id node[:war][:access_key_id]
		aws_secret_access_key node[:war][:access_key_secret]
	end

	action :create
	owner node[:jetty][:user]
	group node[:jetty][:group]
end

=begin
directory "#{node[:nucleusproxy][:god][:goddir]}" do
	action :create
end

directory "#{node[:nucleusproxy][:god][:conditionsdir]}" do
	action :create
end

execute "start-god" do
	user "root"
	command "god"
	action :nothing
end
=end
