# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "mars-berkshelf"
  config.berkshelf.enabled = true

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"
  config.vm.network "forwarded_port", guest: 8080, host: 28080

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
      :war => {
        :environment => "int",
        :version => "1.0-SNAPSHOT",
        :access_key_id => $aws[:dev][:access_key_id],
        :access_key_secret => $aws[:dev][:access_key_secret],
      },
      :logstash => {
        :agent => {
          :base_config => "localtest.agent.conf.erb",
          :debug => true
        }
      }
    }
    chef.run_list = [
      "recipe[mars]"
      #"recipe[logstash::agent]"
    ]
  end
end
