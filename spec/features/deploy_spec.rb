require 'spec_helper'
require './config/deploy'

describe ChefSoloWithVagrant, "loaded into a configuration" do
  before do
    @configuration = Capistrano::Configuration.new
    ChefSoloWithVagrant.load_into(@configuration)
  end
end

describe "#variables" do
  before do
    @configuration = Capistrano::Configuration.new
    ChefSoloWithVagrant.load_into(@configuration)
  end

  it "set use_sudo" do
    @configuration.fetch(:use_sudo).should == true
  end

  it "set chef_binary" do
    @configuration.fetch(:chef_binary).should == "/usr/bin/chef-solo" 
  end

  it "set default_stage" do
    @configuration.fetch(:default_stage).should == "vagrant"
  end

  it "set stages" do
    @configuration.fetch(:stages).sort.should == ["example","vexample","vagrant"].sort
  end

  it "set ssh_d" do
    @configuration.fetch(:ssh_d).should == File.realdirpath(File.join(PROJECT_ROOT,".ssh"))
  end

  it "set default_run_options[:pty] = true" do
    @configuration.default_run_options[:pty].should == true
  end

  it "set ssh_options[:forward_agent] = true" do
    @configuration.ssh_options[:forward_agent].should == true
  end

  it "set ssh_options[:config]" do
    @configuration.ssh_options[:config].sort.should == Dir.glob(File.join(PROJECT_ROOT,".ssh","*.rb"))
  end
end

describe "#vg:all" do
  before do
    @configuration = Capistrano::Configuration.new
    ChefSoloWithVagrant.load_into(@configuration)
  end

  it "status" do
    @configuration.find_task("vg:all:status").namespace.should_receive(:system).with("vagrant status")
    @configuration.find_and_execute_task("vg:all:status")
  end
  it "up" do
    @configuration.find_task("vg:all:up").namespace.should_receive(:system).with("vagrant up")
    @configuration.find_and_execute_task("vg:all:up")
  end
  it "halt" do
    @configuration.find_task("vg:all:halt").namespace.should_receive(:system).with("vagrant halt")
    @configuration.find_and_execute_task("vg:all:halt")
  end
  it "destroy" do
    @configuration.find_task("vg:all:destroy").namespace.should_receive(:system).with("vagrant destroy")
    @configuration.find_and_execute_task("vg:all:destroy")
  end
end

describe "#vg" do
  before do
    @configuration = Capistrano::Configuration.new
    ChefSoloWithVagrant.load_into(@configuration)
  end

  it "status" do
    @configuration.find_and_execute_task("vexample")
    @configuration.stage.should == :vexample
    @configuration.find_task("vg:status").namespace.should_receive(:system).with("vagrant status vexample")
    @configuration.find_and_execute_task("vg:status")
  end

  it "up" do
    @configuration.find_and_execute_task("vexample")
    @configuration.stage.should == :vexample
    @configuration.find_task("vg:up").namespace.should_receive(:system).with("vagrant up vexample")
    @configuration.find_task("ssh:generate_config").namespace.should_receive(:system).with("mkdir -p #{File.realdirpath(File.join(PROJECT_ROOT,'.ssh'))}")
    @configuration.find_task("ssh:generate_config").namespace.should_receive(:system).with("vagrant ssh-config vexample > #{File.realdirpath(File.join(PROJECT_ROOT,'.ssh','vexample_ssh_config'))}")
    @configuration.find_and_execute_task("vg:up")
  end

  it "halt" do
    @configuration.find_and_execute_task("vexample")
    @configuration.stage.should == :vexample
    @configuration.find_task("vg:halt").namespace.should_receive(:system).with("vagrant halt vexample")
    @configuration.find_task("ssh:destroy_config").namespace.should_receive(:system).with("rm #{File.realdirpath(File.join(PROJECT_ROOT,'.ssh','vexample_ssh_config'))}")
    @configuration.find_and_execute_task("vg:halt")
  end

  it "destroy" do
    @configuration.find_and_execute_task("vexample")
    @configuration.stage.should == :vexample
    @configuration.find_task("vg:destroy").namespace.should_receive(:system).with("vagrant destroy -f vexample")
    @configuration.find_task("ssh:destroy_config").namespace.should_receive(:system).with("rm #{File.realdirpath(File.join(PROJECT_ROOT,'.ssh','vexample_ssh_config'))}")
    @configuration.find_and_execute_task("vg:destroy")
  end
end

describe "#berks" do
  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend(Capistrano::Spec::ConfigurationExtension)
    ChefSoloWithVagrant.load_into(@configuration)
  end

  it "default" do
    @configuration.find_task("berks").namespace.should_receive(:system).with("berks install --path chef/cookbooks/")
    @configuration.find_and_execute_task("berks")
  end
end

describe "#bootstrap" do
  before do
    @configuration = Capistrano::Configuration.new
    ChefSoloWithVagrant.load_into(@configuration)
  end
end
