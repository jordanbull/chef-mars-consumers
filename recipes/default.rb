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

print "#{node[:nucleusproxy][:source][:s3][:bucket]} / #{node[:nucleusproxy][:source][:s3][:fullpath]}"

s3_file "#{node[:jetty][:webappsdir]}/#{node[:nucleusproxy][:localwar]}" do
	remote_path "#{node[:nucleusproxy][:source][:s3][:fullpath]}"
	#remote_path "tnt-nucleus/integration/1-22-3/tnt-nucleus-1.22.3.war"
	bucket "#{node[:nucleusproxy][:source][:s3][:bucket]}"
	if node[:nucleus][:access_key_id]
		aws_access_key_id node[:nucleus][:access_key_id]
		aws_secret_access_key node[:nucleus][:access_key_secret]
	end
	action :create
	owner node[:jetty][:user]
	group node[:jetty][:group]
end