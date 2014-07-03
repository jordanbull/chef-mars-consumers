# general project attributes
default[:war][:name] = "mars"
default[:war][:version] = "1.0-SNAPSHOT"
default[:war][:environment] = "dev"

# mars-specific properties
default[:mars][:queue] = "MAT"
default[:mars][:properties] = "int"
default[:mars][:app_logs] = "/var/log/#{node[:war][:name]}/#{node[:war][:name]}.log"
default[:mars][:opsworks][:layers] = {
	"mars-burstly-consumers"       => "BURSTLY",
	"mars-nanigans-consumers"      => "NANIGANS",
	"mars-fiksu-ios-consumers"     => "FIKSU_IOS",
	"mars-fiksu-android-consumers" => "FIKSU_ANDROID",
	"mars-mat-consumers"           => "MAT",
	"mars-kochava-consumers"       => "KOCHAVA"
}

# default to empty list when running Chef without AWS OpsWorks
default[:opsworks][:instance][:layers] = []

# general tnt deployment attributes
default[:war][:source][:warfile] = "#{node[:war][:name]}-#{node[:war][:version]}.war"
default[:war][:source][:s3][:bucket] = "tnt-build-release"
default[:war][:source][:s3][:path] = "#{node[:war][:name]}/bamboo"
default[:war][:source][:s3][:fullpath] = "#{node[:war][:source][:s3][:path]}/#{node[:war][:source][:warfile]}"
default[:war][:localwar] = "root.war"

default[:java][:jdk_version] = 7
default[:java][:install_flavor] = "openjdk"
