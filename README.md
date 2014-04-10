# nucleus cookbook

Pulls a specified version of the TNT Nucleus Proxy from the build/release bucket and installs it in a Jetty server. Additionally configures logstash agent to push logs to an SQS queue.

# Requirements

# Usage

# Attributes

* `default[:nucleusproxy][:environment]` - the TNT environment being deployed to
* `default[:nucleusproxy][:version]` - version of the warfile to deploy
* `default[:nucleusproxy][:source][:warfile]` - name of the warfile; defaults to `tnt-nucleus-#{node[:nucleusproxy][:version]}.war`
* `default[:nucleusproxy][:source][:s3][:bucket]` - name of the bucket to find the war in
* `default[:nucleusproxy][:source][:s3][:path]` - path within the S3 bucket
* `default[:nucleusproxy][:localwar]` - name of the warfile deployed to jetty; defaults to `root.war`

# Recipes

# Author
