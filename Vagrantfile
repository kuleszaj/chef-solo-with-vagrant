# -*- mode: ruby -*-
# vi: set ft=ruby :

@user_configuration = {}
load File.join(File.dirname(__FILE__),"config","stages.rb")

# This is specifically design for VirtualBox. You could fairly easily adapt it to another Vagrant provider such as VMWare Fusion or AWS.
Vagrant.configure("2") do |config|

  config.ssh.forward_agent = true

  # These types of options should be project specific:
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  @user_configuration["vagrants"].each do |name|
    config.vm.define "#{name}" do |vagrant|
      vagrant.vm.hostname = "#{name}"
      vagrant.vm.network :private_network, type: :dhcp
    end
  end
end
