default[:mars][:env] = "dev"

layers = node[:opsworks][:instance][:layers]
layer_to_queue_map = if node[:mars].nil? || node[:mars][:consumers].nil? || node[:mars][:consumers][:layer_to_queue_map].nil?
						raise "node[:mars][:consumers][:layer_to_queue_map] is not set"
					else
						node[:mars][:consumers][:layer_to_queue_map]
					end
queue = if layers.size != 1
			raise "layers.size is not 1"
		elsif !layer_to_queue_map.has_key?(layers.first)
			raise "Coule not find mapping in 'node[:mars][:consumers][:layer_to_queue_map]' for key '#{layers.first}'"
		else
			layer_to_queue_map[layers.first]
		end

default['opsworks_java']['tomcat']['java_opts'] = "#{node[:opsworks_java][:jvm_options]} -Dspring.profiles.active=consumer -Dmars.env=#{node[:mars][:env]} -Dmars.consumer.inputqueue=#{queue}"