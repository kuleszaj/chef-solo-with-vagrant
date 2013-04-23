#!/usr/bin/env ruby

#
# Infrastructure Capistrano Configuration
# Copyright (C) 2013 Atomic Object, LLC
# Version 0.0.1
#

require 'capistrano'

module ChefSoloWithVagrant

  def self.load_into(configuration)
    configuration.load do

      # Capistrano multistage is required.
      require "capistrano/ext/multistage"

      # Pry may be useful for debugging
      #require "pry"

      # This is where we expect the chef-solo binary to be located (can be overriden in a specific stage)
      set :chef_binary, "/usr/bin/chef-solo"

      # Dynamically load stages from all *.rb files in config/deploy
      set :stages, Dir.entries(File.join(File.dirname(__FILE__),"deploy")).map{|item|item[/(.*?)(?=.rb)/]}.compact

      # Set default stage to 'vagrant' which is a no-op
      set :default_stage, "vagrant"

      # Allow use of sudo, if we need it
      set :use_sudo, true

      # The project SSH configurations are in .ssh/
      set :ssh_d, File.join(File.dirname(__FILE__),"..",".ssh")

      # By default, use a pseudo-TTY
      default_run_options[:pty] = true 

      # SSH agent forwarding is useful for remote commands that need to use local credentials
      ssh_options[:forward_agent] = true

      # Allow Capistrano to use all configuration files in the ssh_d directory
      ssh_options[:config] = Dir.glob("#{ssh_d}/*")
      set :chef_binary, "/usr/bin/chef-solo"

      # SSH Namespace
      namespace :ssh do
        desc "Create SSH configuration file for {stage}. (Vagrant only)"
        # This is only useful for Vagrant stages -- it will not work for any Production stages
        task :generate_config do
          puts "Generating #{ssh_d}/#{stage}_ssh_config..."
          # Create the `ssh_d` directory if it doesn't already exist.
          system("mkdir -p #{ssh_d}")
          # Use Vagrant to generate the SSH config
          system("vagrant ssh-config #{stage} > #{ssh_d}/#{stage}_ssh_config")
        end

        desc "Destroy SSH configuration file for {stage}. (Vagrant only)"
        # This is only useful for Vagrant stages -- it will delete the SSH configuration file for Production stages, which is likely not desired
        task :destroy_config do
          puts "Destroying #{ssh_d}/#{stage}_ssh_config..."
          # Detroy the existing SSH config
          system("rm #{ssh_d}/#{stage}_ssh_config")
        end

        desc "Pretty-print SSH configuration file for {stage}."
        task :show_config do
          require 'PP'
          netssh_config = Net::SSH::Config.for("#{stage}", ssh_options[:config])
          pp netssh_config
        end

        desc "SSH into the system specified by {stage} using its SSH configuration file"
        task :default do
          system("ssh -F #{ssh_d}/#{stage}_ssh_config #{stage}")
        end
      end

      # Bootstrap Namespace
      namespace :bootstrap do
        desc "Bootstrap Chef on {stage}"
        task :default do
          # Use the loaded SSH configuration info to connect to {stage} with knife and bootstrap the system with Chef.
          set :user, Net::SSH::Config.for("#{stage}", ssh_options[:config])[:user]
          set :id_file, Net::SSH::Config.for("#{stage}", ssh_options[:config])[:keys][0] if Net::SSH::Config.for("#{stage}", ssh_options[:config]).has_key?(:keys)
          set :hostname, Net::SSH::Config.for("#{stage}", ssh_options[:config])[:host_name]
          set :hostport, Net::SSH::Config.for("#{stage}", ssh_options[:config])[:port] || 22
          # If there is an `id_file`, use it.  Otherwise, fall back to default knife behavior (ask for password)
          if exists?(:id_file)
            system("cd chef && knife bootstrap --bootstrap-version '11.4.2' -d chef-solo -x #{user} -i #{id_file} --sudo #{hostname} -p #{hostport}")
          else
            system("cd chef && knife bootstrap --bootstrap-version '11.4.2' -d chef-solo -x #{user} --sudo #{hostname} -p #{hostport}")
          end
        end
      end

      # Berks Namespace
      namespace :berks do
        desc "Vendorize cookbooks from the Berksfile into chef/cookbooks"
        task :default do
          system("berks install --path chef/cookbooks/")
        end
      end

      # Chef Namespace
      namespace :chef do
        desc "Create a TGZ from chef/, upload it, and run chef solo against it on {stage}"
        task :default do
          # Get appropriate username from the loaded SSH configuration info for this {stage}
          set :user, Net::SSH::Config.for("#{stage}", ssh_options[:config])[:user]

          if user[/root/]
            system("tar czf 'chef.tar.gz' -C chef/ .")
            upload("chef.tar.gz","/root",:via => :scp)
            run("rm -rf /root/chef")
            run("mkdir -p /root/chef")
            run("tar xzf 'chef.tar.gz' -C /root/chef")
            sudo("/bin/bash -c 'cd /root/chef && #{chef_binary} -c solo.rb -j #{stage}.json -N #{stage} --color'")
          else 
            system("tar czf 'chef.tar.gz' -C chef/ .")
            upload("chef.tar.gz","/home/#{user}",:via => :scp)
            run("rm -rf /home/#{user}/chef")
            run("mkdir -p /home/#{user}/chef")
            run("tar xzf 'chef.tar.gz' -C /home/#{user}/chef")
            sudo("/bin/bash -c 'cd /home/#{user}/chef && #{chef_binary} -c solo.rb -j #{stage}.json -N #{stage} --color'")
          end
        end
      end

      # Warning Namespace
      namespace :warning do
        desc "Show a warning if running against a Production {stage}"
        task :warning do
          # This might be useful for Production stages
          logger.log(0,"*\n*\n*\n*\t\t\t!!  W A R N I N G  !!\n*\n*\t\tYou are about to run a POTENTIALLY DESTRUCTIVE action on #{stage.upcase}.\n*\n*\t\tIf you did not intend to do this, press CTRL + C now.\n*\n*\n*")
          sleep 5
        end
      end

      # VG Namespace (for specific Vagrant {stage})
      namespace :vg do
        desc "Boot Vagrant VM & generate SSH config."
        task :up do
          system("vagrant up #{stage}")
          find_and_execute_task("ssh:generate_config")
        end

        desc "Halt Vagrant VM & destroy SSH config."
        task :halt do
          system("vagrant halt #{stage}")
          find_and_execute_task("ssh:destroy_config")
        end

        desc "Destroy Vagrant VM & remove SSH config."
        task :destroy do
          system("vagrant destroy -f #{stage}")
          find_and_execute_task("ssh:destroy_config")
        end

        desc "Show status of Vagrant VM."
        task :status do
          system("vagrant status #{stage}")
        end

        # VG ALL Namespace (for all available Vagrants)
        namespace :all do
          desc "Show status of all Vagrant VM."
          task :status do
            system("vagrant status")
          end

          desc "Boot all Vagrant VM's."
          task :up do
            system("vagrant status")
          end

          desc "Destroy all Vagrant VM's."
          task :destroy do
            system("vagrant destroy")
          end

          desc "Halt all Vagrant VM's."
          task :halt do
            system("vagrant halt")
          end
        end
      end

      namespace :simple_test do
        desc "testing"
        task :echo do
          system("echo 'test'")
        end
      end

      # Load custom, machine/cluster specific configs from config/custom 
      Dir.glob(File.join(File.dirname(__FILE__),"custom","*.rb")).each{|file|load "#{file}"}

    end
  end
end

if Capistrano::Configuration.instance
  ChefSoloWithVagrant.load_into(Capistrano::Configuration.instance)
end
