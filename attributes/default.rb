# mars-specific properties
default[:mars][:app_logs] = "/var/log/#{node[:war][:name]}/#{node[:war][:name]}.log"
default[:mars][:properties] = "int"

# general project attributes
default[:war][:name] = "mars"
default[:war][:version] = "1.0-SNAPSHOT"
default[:war][:environment] = "dev"

# general tnt deployment attributes
default[:war][:source][:warfile] = "#{node[:war][:name]}-#{node[:war][:version]}.war"
default[:war][:source][:s3][:bucket] = "tnt-build-release"
default[:war][:source][:s3][:path] = "#{node[:war][:name]}/bamboo"
default[:war][:source][:s3][:fullpath] = "#{node[:war][:source][:s3][:path]}/#{node[:war][:source][:warfile]}"
default[:war][:localwar] = "root.war"

default[:java][:jdk_version] = 7
default[:java][:install_flavor] = "openjdk"

=begin
default[:war][:god][:goddir] = "/opt/god"
default[:war][:god][:conditionsdir] = "/opt/god/conditions"
default[:war][:god][:notification][:from] = "TNTTeamKitchener@ea.com"
default[:war][:god][:notification][:to] = "TNTTeamKitchener@ea.com"

default[:war][:smtp][:user] = ""
default[:war][:smtp][:pass] = ""
default[:war][:smtp][:tunnel][:host] = "localhost"
default[:war][:smtp][:tunnel][:port] = "2525"
default[:war][:smtp][:host] = "email-smtp.us-east-1.amazonaws.com"
default[:war][:smtp][:port] = "465"
default[:war][:email][:domain] = "ea.com"

default[:logstash][:agent][:version] = "1.3.3"
default[:logstash][:agent][:source_url] = "https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar"
default[:logstash][:agent][:debug] = false
default[:logstash][:agent][:base_config_cookbook] = "nucleus-proxy"
default[:logstash][:agent][:base_config] = "agent.conf.erb"
=end
