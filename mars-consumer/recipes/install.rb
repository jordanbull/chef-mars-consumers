Chef::Log.info "Starting Installation."

Chef::Log.info "  Creating Sumo Logic director at #{node['sumologic']['installDir']}"

directory node['sumologic']['installDir']  do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

Chef::Log.info "  Downloading Sumo Logic installer from #{node['sumologic']['downloadURL']}"

remote_file "#{node['sumologic']['installDir']}/#{node['sumologic']['installerName']}" do
  source node['sumologic']['downloadURL']
  mode '0644'
end

Chef::Log.info "  Installing Sumo Logic director at #{node['sumologic']['installDir']}"

execute "Deploy Sumo Collector" do
  command "sh #{node['sumologic']['installerName']} -q -dir #{node['sumologic']['installDir']}"
  cwd node['sumologic']['installDir']
  timeout 3600
end