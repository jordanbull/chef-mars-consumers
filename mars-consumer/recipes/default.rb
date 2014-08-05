#
# Cookbook Name:: mars-consumer
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

sumo_access_id = node[:sumologic][:access_id]
sumo_access_key = node[:sumologic][:access_key]
sumo_log_category = node[:sumologic][:category]
sumo_log_source_dir = node[:sumologic][:source_dir]
sumo_collector_config_dir = "/etc/sumocollector"
sumo_collector_config_path = sumo_collector_config_dir + "/collector.json"

if sumo_access_id.nil? || sumo_access_key.nil?
	raise "node[:sumologic][:access_id] and node [:sumologic][:access_key] must be set"
end

if Dir.exist? "#{node['sumologic']['installDir']}"
	log "Sumologic already installed. Nothing to do here."
	return
end

template "/etc/sumo.conf" do
	source "sumo.conf.erb"
	owner 'root'
	group 'root'
	mode 0664

	variables({
		:access_id => sumo_access_id,
		:access_key => sumo_access_key,
		:collector_config_path => sumo_collector_config_path
	})
end

directory "#{sumo_collector_config_dir}" do
	owner "root"
	group "root"
	mode 0644
	action :create
end

template "#{sumo_collector_config_path}" do
	source 'collector.json.erb'
	owner 'root'
	group 'root'
	mode 0644
	variables({
		:category => sumo_log_category,
		:source_dir => sumo_log_source_dir
	})
end

include_recipe 'mars-consumer::install'