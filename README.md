# MARS Consumers Cookbook

Pulls a specified version of the MARS service from the build/release bucket and overrides opsworks_java attributes to start tomcat server with custom jvm flags.

# Usage

## Configuring for General Use
This Cookbook is intended for use with AWS OpsWorks, but could be repurposed to work with Chef anywhere.

# Attributes

| Attribute | Default Value | Description |
| --------- | ------------- | ----------- |
| `default[:sumologic][:access_id]` | nil | sumologic access key id |
| `default[:sumologic][:access_key]` | nil | sumologic access key secrete |
| `default[:sumologic][:source_name]` | `EB-MARS-#{node[:mars][:env]}` | sumologic collector source name |
| `default[:sumologic][:category]` | `EB-MARS-#{node[:mars][:env]}` | sumologic collector category |
| `default[:sumologic][:path_expression]` | `/var/log/tomcat7/mars.log` | sumologic collector log source location |
