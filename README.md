# MARS Consumers Cookbook

Pulls a specified version of the MARS service from the build/release bucket and installs it in a Jetty server.

# Usage

## Configuring for General Use
This Cookbook is intended for use with AWS OpsWorks, but could be repurposed to work with Chef anywhere.

The only dependency on OpsWorks is the `node[:opsworks][:instance][:layers]` attribute, which is used to determine which queue to consume from (see default.rb:34-39)

## OpsWorks Configuration
Note that Chef Attributes are specific to an OpsWorks Stack, and cannot be overridden on a per-Layer basis.

In order to designate a layer as a consumer for a specific queue you must specify one of several *specific* Layer short names.

You can use anything for the Layer Name, but the short name must be one of the following options:
 1. mars-burstly-consumers
 2. mars-nanigans-consumers
 3. mars-fiksu-ios-consumers
 4. mars-fiksu-android-consumers
 5. mars-mat-consumers
 6. mars-kochava-consumers

# Attributes

| Attribute | Default Value | Description |
| --------- | ------------- | ----------- |
| `default[:mars][:queue]` | `MAT` | The queue to consume messages from |
| `default[:war][:name]` | `mars` | Name of the artifact to deploy |
| `default[:war][:version]` | `1.0-SNAPSHOT` | Version of the warfile to deploy |
| `default[:war][:environment]` | `dev` | The TNT environment being deployed to |
| `default[:war][:source][:warfile]` | `#{node[:war][:name]}-#{node[:war][:version]}.war` | Name of the warfile |
| `default[:war][:source][:s3][:bucket]` | `tnt-build-release` | Name of the bucket to find the war in |
| `default[:war][:source][:s3][:path]` | `#{node[:war][:name]}/bamboo` | Path within the S3 bucket |
| `default[:war][:localwar]` | `root.war` | Name of the warfile deployed to jetty |
| `default[:war][:logs][:application]` | `/var/log/#{node[:war][:name]}/#{node[:war][:name]}.log` | The file path for the application logs file |

## `default[:mars][:queue]`

 * The default queue to use, if it cannot be inferred from the OpsWorks Layer short name
 * Should be one of MAT, NANIGANS, FIKSU_IOS , FIKSU_ANDROID, BURSTLY, or KOCHAVA

## `default[:mars][:opsworks][:layers]`

The map of layer short names to built-in queue consumers
```
{
	"mars-burstly-consumers":       "BURSTLY",
	"mars-nanigans-consumers":      "NANIGANS",
	"mars-fiksu-ios-consumers":     "FIKSU_IOS",
	"mars-fiksu-android-consumers": "FIKSU_ANDROID",
	"mars-mat-consumers":           "MAT",
	"mars-kochava-consumers":       "KOCHAVA"
}
```

# Recipes

`mars`
