# general project attributes
default[:war][:name] = "mars"
default[:war][:version] = "1.0-SNAPSHOT"

# mars-specific properties
default[:mars][:env] = "dev"
default[:mars][:input_queue] = nil
default[:mars][:properties] = "#{node[:mars][:env]}"
default[:mars][:app_logs] = "/var/log/#{node[:war][:name]}/#{node[:war][:name]}.log"
default[:mars][:opsworks][:layers] = {
	"mars-burstly-consumers"       => "mars-burstly-#{node[:mars][:env]}",
	"mars-nanigans-consumers"      => "mars-nanigans-#{node[:mars][:env]}",
	"mars-fiksu-ios-consumers"     => "mars-fiksu_ios-#{node[:mars][:env]}",
	"mars-fiksu-android-consumers" => "mars-fiksu_android-#{node[:mars][:env]}",
	"mars-mat-consumers"           => "mars-mat-#{node[:mars][:env]}",
	"mars-kochava-consumers"       => "mars-kochava-#{node[:mars][:env]}"
}

# default to empty list when running Chef without AWS OpsWorks
# AWS will populate it for us when we *are* running in OpsWorks
default[:opsworks][:instance][:layers] = []

# general tnt deployment attributes
default[:war][:source][:warfile] = "#{node[:war][:name]}-#{node[:war][:version]}.war"
default[:war][:source][:s3][:bucket] = "tnt-build-release"
default[:war][:source][:s3][:path] = "#{node[:war][:name]}"
default[:war][:source][:s3][:fullpath] = "#{node[:war][:source][:s3][:path]}/#{node[:war][:source][:warfile]}"
default[:war][:localwar] = "root.war"

default[:java][:jdk_version] = 7
default[:java][:install_flavor] = "openjdk"
