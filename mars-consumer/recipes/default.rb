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
sumo_log_source_name = node[:sumologic][:source_name]
sumo_log_path_express = node[:sumologic][:path_expression]
sumo_collector_config_dir = "/etc/sumocollector"
sumo_collector_rpm_path = sumo_collector_config_dir + "/SumoCollector.rpm"
sumo_collector_config_path = sumo_collector_config_dir + "/collector.json"

if sumo_access_id.nil? || sumo_access_key.nil?
	raise "node[:sumologic][:access_id] and node [:sumologic][:access_key] must be set"
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
		:source_name => sumo_log_source_name,
		:path_expression => sumo_log_path_express
	})
end

remote_file "#{sumo_collector_rpm_path}" do
	owner "root"
	group "root"
	source "https://collectors.sumologic.com/rest/download/rpm/64"
	action :create
end

apt_package "rpm" do
  action :install
end

rpm_package "SumoCollector" do
	source "#{sumo_collector_rpm_path}"
	action :install
end