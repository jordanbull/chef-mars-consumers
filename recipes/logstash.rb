#
# Cookbook Name:: nucleus
# Recipe:: logstash
#
# Copyright (C) 2014 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

node.override[:logstash][:agent][:base_config] = "localtest.agent.conf.erb"

include_recipe 'logstash::agent'