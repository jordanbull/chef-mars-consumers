default[:nucleusproxy][:environment] = "dev"
default[:nucleusproxy][:version] = "1.22.5-SNAPSHOT"
default[:nucleusproxy][:source][:warfile] = "tnt-nucleus-#{node[:nucleusproxy][:version]}.war"
default[:nucleusproxy][:source][:s3][:bucket] = "tnt-build-release"
default[:nucleusproxy][:source][:s3][:path] = "tnt-nucleus/bamboo"
default[:nucleusproxy][:source][:s3][:fullpath] = "#{node[:nucleusproxy][:source][:s3][:path]}/#{node[:nucleusproxy][:source][:warfile]}"
default[:nucleusproxy][:localwar] = "root.war"

default[:nucleusproxy][:god][:goddir] = "/opt/god"
default[:nucleusproxy][:god][:conditionsdir] = "/opt/god/conditions"

default[:java][:jdk_version] = 7
default[:java][:install_flavor] = "openjdk"

default[:logstash][:agent][:version] = "1.3.3"
default[:logstash][:agent][:source_url] = "https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar"
default[:logstash][:agent][:debug] = false
default[:logstash][:agent][:base_config_cookbook] = "nucleus-proxy"
default[:logstash][:agent][:base_config] = "agent.conf.erb"