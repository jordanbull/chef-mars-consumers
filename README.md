# MARS Consumers Cookbook

Pulls a specified version of the MARS service from the build/release bucket and overrides opsworks_java attributes to start tomcat server with custom jvm flags.

# Usage

## Configuring for General Use
This Cookbook is intended for use with AWS OpsWorks, but could be repurposed to work with Chef anywhere.

# Attributes

| Attribute | Default Value | Description |
| --------- | ------------- | ----------- |
| `default[:mars][:env]` | `dev` | mars environment |
| `default[:war][:version]` | `1.0-SNAPSHOT` | Version of the warfile to deploy |
| `default[:mars][:consumers][:layer_to_queue_map]` | nil | opsworks layer short name to consumer input queue map |
| `default[:sumologic][:access_id]` | nil | sumologic access key id |
| `default[:sumologic][:access_key]` | nil | sumologic access key secrete |
| `default[:sumologic][:source_name]` | `EB-MARS-#{node[:mars][:env]}` | sumologic collector source name |
| `default[:sumologic][:category]` | `EB-MARS-#{node[:mars][:env]}` | sumologic collector category |
| `default[:sumologic][:path_expression]` | `/var/log/tomcat7/mars.log` | sumologic collector log source location |

## `default[:mars][:consumers][:layer_to_queue_map]`

Example map of layer short names to input queue
```
"layer_to_queue_map" : {
	"mars-burstly-consumers"		: "mars-dev-burstly",
	"mars-nanigans-consumers"		: "mars-dev-nanigans",
	"mars-fiksu-consumers"			: "mars-dev-fiksu",
	"mars-mat-consumers"			: "mars-dev-mat",
	"mars-chartboost-consumers"		: "mars-dev-chartboost"
}
```

# Example opsworks stack custom json
```
{
	"sumologic" : {
		"access_id" : "{access_id}",
		"access_key" : "{access_key}"
	},
	"mars" : {
		"env" : "dev",
		"consumers" : {
			"layer_to_queue_map" : insert above layer_to_queue_map example
		}
	},
	"war" : {
		"version" : "develop-20"
	}
}
```