default[:mars][:env] = "dev"

default[:mars][:consumers][:layer_to_queuemap] = {
	"mars-burstly-consumers"       => "burstly",
	"mars-nanigans-consumers"      => "nanigans",
	"mars-fiksu-ios-consumers"     => "fiksu_ios",
	"mars-fiksu-android-consumers" => "fiksu_android",
	"mars-mat-consumers"           => "mat",
	"mars-kochava-consumers"       => "kochava"
}

layers = node[:opsworks][:instance][:layers]
layer_to_queuemap = node[:mars][:consumers][:layer_to_queuemap]
queue = if layers.size == 1 && layer_to_queuemap.has_key?(layers.first)
			layer_to_queuemap[layers.first]
		else
			raise "Coule not find mapping in 'node[:mars][:consumers][:layer_to_queuemap]' for key '#{layer_to_queuemap[layers.first]}'"
		end

case queue
when 'burstly'
	default[:mars][:queueName] = "mars-burstly-#{node[:mars][:env]}"
when 'nanigans'
	default[:mars][:queueName] = "mars-nanigans-#{node[:mars][:env]}"
when 'fiksu-ios'
	default[:mars][:queueName] = "mars-fiksu_ios-#{node[:mars][:env]}"
when 'fiksu-android'
	default[:mars][:queueName] = "mars-fiksu_android-#{node[:mars][:env]}"
when 'mat'
	default[:mars][:queueName] = "mars-mat-#{node[:mars][:env]}"
when 'kochava'
	default[:mars][:queueName] = "mars-kochava-#{node[:mars][:env]}"
end
default['opsworks_java']['tomcat']['java_opts'] = "#{node[:opsworks_java][:jvm_options]} -Dspring.profiles.active=consumer -Dmars.env=#{node[:mars][:env]} -Dmars.consumer.inputqueue=#{node[:mars][:queueName]}"