default[:mars][:env] = "dev"
case node[:opsworks][:instance][:layers].first
when 'mars-burstly-consumers'
	default[:mars][:queueName] = "mars-#{node[:mars][:env]}-burstly"
when 'mars-nanigans-consumers'
	default[:mars][:queueName] = "mars-#{node[:mars][:env]}-nanigans"
when 'mars-fiksu-ios-consumers'
	default[:mars][:queueName] = "mars-#{node[:mars][:env]}-fiksu_ios"
when 'mars-fiksu-android-consumers'
	default[:mars][:queueName] = "mars-#{node[:mars][:env]}-fiksu_android"
when 'mars-fiksu-consumers'
	default[:mars][:queueName] = "mars-#{node[:mars][:env]}-fiksu"
when 'mars-mat-consumers'
	default[:mars][:queueName] = "mars-#{node[:mars][:env]}-mat"
when 'mars-kochava-consumers'
	default[:mars][:queueName] = "mars-#{node[:mars][:env]}-kochava"
end
default['opsworks_java']['tomcat']['java_opts'] = "#{node[:opsworks_java][:jvm_options]} -Dspring.profiles.active=consumer -Dmars.env=#{node[:mars][:env]} -Dmars.consumer.inputqueue=#{node[:mars][:queueName]}"
