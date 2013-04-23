# -*- mode: ruby -*-
# vi: set ft=ruby :

# This is specifically design for VirtualBox. You could fairly easily adapt it to another Vagrant provider such as VMWare Fusion or AWS.
Vagrant.configure("2") do |config|

  config.ssh.forward_agent = true

  # These types of options should be project specific:
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # We add a new Vagrant for each stage in config/deploy
  Dir.entries(File.join(File.dirname(__FILE__),"config","deploy")).map{|item|item[/(v.*?)(?=.rb)/]}.compact.each{|stage|
    next if stage[/vagrant/]
    config.vm.define "#{stage}" do |vagrant|
      vagrant.vm.hostname = "#{stage}"
      vagrant.vm.network :private_network, type: :dhcp
    end
  }
end
