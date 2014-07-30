default[:mars][:env] = "dev"

# sumologic collector attributes
default[:sumologic][:access_id] = nil
default[:sumologic][:access_key] = nil
default[:sumologic][:source_name] = "EB-MARS-#{node[:mars][:env]}"
default[:sumologic][:category] = "EB-MARS-#{node[:mars][:env]}"
default[:sumologic][:path_expression] = "/var/log/tomcat7/mars.log"

#Platform Specific Attributes
case platform
    # Currently have all linux variants using the scripted installer
    when 'redhat', 'centos', 'scientific', 'fedora', 'suse', 'amazon', 'oracle', 'debian', 'ubuntu'
        # Install Path
        default['sumologic']['installDir']     = '/opt/SumoCollector'

        # Installer Name
        default['sumologic']['installerName'] = node['kernel']['machine'] =~ /^i[36']86$/ ? 'SumoCollector_linux32.sh' : 'SumoCollector_linux64.sh'

        # Install Command
        default['sumologic']['installerCmd'] = "sh #{default['sumologic']['installerName']} -q -dir #{default['sumologic']['installDir']}"

        # Download Path - Either 32bit or 64bit according to the architecture
        default['sumologic']['downloadURL'] = node['kernel']['machine'] =~ /^i[36']86$/ ? 'https://collectors.sumologic.com/rest/download/linux/32' : 'https://collectors.sumologic.com/rest/download/linux/64'

    else
        # Just have empty install commands for now as a placeholder

        # Install Path
        default['sumologic']['installDir']     = '/opt/SumoCollector'

        # Installer Name - Either 32bit or 64bit according to the architecture
        default['sumologic']['installerName'] = ''

        # Install Command
        default['sumologic']['installerCmd'] = ''

        # Download Path - Either 32bit or 64bit according to the architecture
        default['sumologic']['downloadURL'] = ''
end