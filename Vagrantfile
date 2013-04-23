# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.ssh.forward_agent = true

  # These types of options should be project specific:
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # You can configure providers in your global vagrant configuration (~/.vagrant.d)
  #config.vm.provider :aws do |aws|
  #  aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
  #  aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  #  aws.keypair_name = ENV['AWS_KEY_PAIR_NAME']
  #  aws.ssh_private_key_path = ENV['AWS_PRIVATE_KEY_PATH']
  #end

  # We add a new Vagrant for each stage in config/deploy
  Dir.entries(File.join(File.dirname(__FILE__),"config","deploy")).map{|item|item[/(v.*?)(?=.rb)/]}.compact.each{|stage|
    next if stage[/vagrant/]
    config.vm.define "#{stage}" do |vagrant|
      vagrant.vm.hostname = "#{stage}"
      vagrant.vm.network :private_network, type: :dhcp
    end
  }
end
