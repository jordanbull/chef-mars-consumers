default[:mars][:env] = "dev"
case node[:opsworks][:instance][:layers].first
when 'mars-burstly-consumers'
	default[:mars][:queueName] = "mars-burstly-#{node[:mars][:env]}"
when 'mars-nanigans-consumers'
	default[:mars][:queueName] = "mars-nanigans-#{node[:mars][:env]}"
when 'mars-fiksu-ios-consumers'
	default[:mars][:queueName] = "mars-fiksu_ios-#{node[:mars][:env]}"
when 'mars-fiksu-android-consumers'
	default[:mars][:queueName] = "mars-fiksu_android-#{node[:mars][:env]}"
when 'mars-mat-consumers'
	default[:mars][:queueName] = "mars-mat-#{node[:mars][:env]}"
when 'mars-kochava-consumers'
	default[:mars][:queueName] = "mars-kochava-#{node[:mars][:env]}"
end
default['opsworks_java']['tomcat']['java_opts'] = "#{node[:opsworks_java][:jvm_options]} -Dspring.profiles.active=consumer -Dmars.env=#{node[:mars][:env]} -Dmars.consumer.inputqueue=#{node[:mars][:queueName]}"