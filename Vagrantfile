# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "nucleus-berkshelf"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"
  config.vm.network "forwarded_port", guest: 8080, host: 18080

  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :java => {
        :jdk_version => 7,
        :install_flavor => "openjdk"
      },
      :jetty => {
      	:user => "vagrant",
      	:group => "vagrant"
      },
      :nucleusproxy => {
      	:access_key_id => $aws[:dev][:access_key_id],
		:access_key_secret => $aws[:dev][:access_key_secret]
      },
      :logstash => {
        :agent => {
          :version => "1.3.3",
          :source_url => "https://download.elasticsearch.org/logstash/logstash/logstash-1.3.3-flatjar.jar",
          :debug => true,
          :base_config_cookbook => "nucleus-proxy",
          :base_config => "agent.conf.erb",
        }
      }
    }
    chef.run_list = [
      #"recipe[jetty::default]",
      #"recipe[jetty::logback]",
      #"recipe[logstash::agent]",
      "recipe[nucleus-proxy]"
    ]
  end
end
