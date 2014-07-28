default[:mars][:env] = "dev"

# sumologic collector attributes
default[:sumologic][:access_id] = nil
default[:sumologic][:access_key] = nil
default[:sumologic][:source_name] = "EB-MARS-#{node[:mars][:env]}"
default[:sumologic][:path_expression] = "/var/log/tomcat7/mars.log"