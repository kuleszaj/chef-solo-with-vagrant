#!/usr/bin/env ruby
# Infrastructure Capistrano Configuration
# Copyright (C) 2013 Atomic Object, LLC
# Version 0.0.1

# Capistrano multistage is required.
#require "capistrano/ext/multistage"

# Pry may be useful for debugging
#require "pry"

# This is where we expect the chef-solo binary to be located (can be overriden in a specific stage)
set :chef_binary, "/usr/bin/chef-solo"

begin

  @user_configuration = {}

  load File.join(File.dirname(__FILE__),"stages.rb")

  @user_configuration["servers"].each do |name|
    desc "Set the target stage to `#{name}`."
    task (name) do
      set :stage, name.to_sym
      set :stage_type, "server"
    end
  end

  @user_configuration["vagrants"].each do |name|
    desc "Set the target stage to `#{name}`."
    task (name) do
      set :stage, name.to_sym
      set :stage_type, "vagrant"
    end
  end

rescue Exception => e

  puts e
  logger.log(0,"Either the Array of vagrants or servers was not specified properly")
  exit(1)

end

# Dynamically load stages from all *.rb files in config/deploy
#set :stages, Dir.entries(File.join(File.dirname(__FILE__),"deploy")).map{|item|item[/(.*?)(?=.rb)/]}.compact

# Set default stage to 'vagrant' which is a no-op
#set :default_stage, "vagrant"

# Allow use of sudo, if we need it
set :use_sudo, true

# The project SSH configurations are in ~/.ssh/projectname; currently chef-solo-with-capistrano
set :ssh_d, File.join(Dir.home,".ssh","chef-solo-with-capistrano")

# By default, use a pseudo-TTY
default_run_options[:pty] = true 

# SSH agent forwarding is useful for remote commands that need to use local credentials
ssh_options[:forward_agent] = true

# Allow Capistrano to use all configuration files in the ssh_d directory
ssh_options[:config] = Dir.glob("#{ssh_d}/*")

# Load all of our namespaces and tasks
Dir.glob(File.join(File.dirname(__FILE__),"base","*.rb")).each{|file|load "#{file}"}

# Load custom, machine/cluster specific configs from config/custom
Dir.glob(File.join(File.dirname(__FILE__),"custom","*.rb")).each{|file|load "#{file}"}
