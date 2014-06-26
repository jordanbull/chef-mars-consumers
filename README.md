# MARS Consumers Cookbook

Pulls a specified version of the MARS service from the build/release bucket and installs it in a Jetty server. Additionally configures logstash agent to push logs to an SQS queue.

# Requirements

# Usage

# Attributes

| Attribute | Default Value | Description |
| --------- | ------------- | ----------- |
| `default[:war][:name]` | `mars` | Name of the artifact to deploy |
| `default[:war][:version]` | `1.0-SNAPSHOT` | Version of the warfile to deploy |
| `default[:war][:environment]` | `dev` | The TNT environment being deployed to |
| `default[:war][:source][:warfile]` | `#{node[:war][:name]}-#{node[:war][:version]}.war` | Name of the warfile |
| `default[:war][:source][:s3][:bucket]` | `tnt-build-release` | Name of the bucket to find the war in |
| `default[:war][:source][:s3][:path]` | `#{node[:war][:name]}/bamboo` | Path within the S3 bucket |
| `default[:war][:localwar]` | `root.war` | Name of the warfile deployed to jetty |
| `default[:war][:logs][:application]` | `/var/log/#{node[:war][:name]}/#{node[:war][:name]}.log` | The file path for the application logs file |

# Recipes

# Author
