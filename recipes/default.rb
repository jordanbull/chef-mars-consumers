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

# figure out queue name by opsworks layer name
layers = node[:opsworks][:instance][:layers]
layer_to_queuemap = node[:mars][:consumers][:layer_to_queuemap]
queuemap = default[:mars][:queue][:map]
queue = if node[:mars].attribute?(:input_queue) && node[:mars][:input_queue] != nil
			node[:mars][:input_queue]
		elsif layers.size == 1 and layer_to_queuemap.has_key?(layers.first)
			if queuemap.has_key?(layer_to_queuemap[layers.first])
				queuemap[layer_to_queuemap[layers.first]]
			else
				raise "Coule not find mapping for queuename for 'key #{layer_to_queuemap[layers.first]}'"
			end
		else
			raise "Could not determine queue from either layer or attribute."
		end


template "#{node[:jetty][:homedir]}/start.ini" do
	source "start.ini.erb"
	owner node[:jetty][:user]
	group node[:jetty][:group]
	
	variables({
		:queue => queue,
		:environment => node[:mars][:env],
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
