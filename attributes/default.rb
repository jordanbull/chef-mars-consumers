# general project attributes
default[:war][:name] = "mars"
default[:war][:version] = "1.0-SNAPSHOT"
default[:war][:environment] = "dev"

# mars-specific properties
default[:mars][:queue] = "MAT"
default[:mars][:properties] = "int"
default[:mars][:app_logs] = "/var/log/#{node[:war][:name]}/#{node[:war][:name]}.log"

# general tnt deployment attributes
default[:war][:source][:warfile] = "#{node[:war][:name]}-#{node[:war][:version]}.war"
default[:war][:source][:s3][:bucket] = "tnt-build-release"
default[:war][:source][:s3][:path] = "#{node[:war][:name]}/bamboo"
default[:war][:source][:s3][:fullpath] = "#{node[:war][:source][:s3][:path]}/#{node[:war][:source][:warfile]}"
default[:war][:localwar] = "root.war"

default[:java][:jdk_version] = 7
default[:java][:install_flavor] = "openjdk"
