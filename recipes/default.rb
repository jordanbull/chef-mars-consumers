#
# Cookbook Name:: mars
# Recipe:: default
#
# Copyright (C) 2014 Electronic Arts
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'java'
include_recipe 'jetty::default'

apt_package "build-essential" do
	action :install
end

template "#{node[:jetty][:homedir]}/start.ini" do
	source "start.ini.erb"
	owner node[:jetty][:user]
	group node[:jetty][:group]

	variables({
		:queue => queueForLayer(node),
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

def queueForLayer(node)
	layers = node[:opsworks][:instance][:layers]
	map = node[:mars][:opsworks][:layers]
	queue = if layers.size == 1 and map.has_key?(layers.first)
		map[layers.first]
	else
		node[:mars][:queue]
	end

	log "Mars Consumer for: #{queue}"
	queue
end
