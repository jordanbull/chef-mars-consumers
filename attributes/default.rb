# general project attributes
default[:war][:name] = "mars"
default[:war][:version] = "1.0-SNAPSHOT"

# mars-specific properties
default[:mars][:env] = "dev"
default[:mars][:input_queue] = nil
default[:mars][:properties] = "#{node[:mars][:env]}"
default[:mars][:app_logs] = "/var/log/#{node[:war][:name]}/#{node[:war][:name]}.log"

default[:mars][:consumers][:layer_to_queuemap] = {
	"mars-burstly-consumers"       => "burstly",
	"mars-nanigans-consumers"      => "nanigans",
	"mars-fiksu-ios-consumers"     => "fiksu_ios",
	"mars-fiksu-android-consumers" => "fiksu_android",
	"mars-mat-consumers"           => "mat",
	"mars-kochava-consumers"       => "kochava"
}

default[:mars][:queue][:map] = {
	"burstly"       => "mars-burstly-#{node[:mars][:env]}",
	"nanigans"      => "mars-nanigans-#{node[:mars][:env]}",
	"fiksu-ios"     => "mars-fiksu_ios-#{node[:mars][:env]}",
	"fiksu-android" => "mars-fiksu_android-#{node[:mars][:env]}",
	"mat"           => "mars-mat-#{node[:mars][:env]}",
	"kochava"       => "mars-kochava-#{node[:mars][:env]}"
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
