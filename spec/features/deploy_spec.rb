require 'spec_helper'
require './config/deploy'

describe ChefSoloWithVagrant, "loaded into a configuration" do
  before do
    @configuration = Capistrano::Configuration.new
    ChefSoloWithVagrant.load_into(@configuration)
  end
end

describe "default variables" do
  before do
    @configuration = Capistrano::Configuration.new
    ChefSoloWithVagrant.load_into(@configuration)
  end

  it "should use sudo" do
    @configuration.fetch(:use_sudo).should == true
  end

  it "should have the path to the chef binary set" do
    @configuration.fetch(:chef_binary).should == "/usr/bin/chef-solo" 
  end

  it "should have a default stage set" do
    @configuration.fetch(:default_stage).should == "vagrant"
  end

  it "should detect and load all available stages" do
    @configuration.fetch(:stages).sort.should === ["example","vexample","vagrant"].sort
  end
end

describe "global vagrant commands" do
  before do
    @configuration = Capistrano::Configuration.new
    @configuration.extend(Capistrano::Spec::ConfigurationExtension)
    ChefSoloWithVagrant.load_into(@configuration)
  end

  it "should echo" do
    @configuration.find_and_execute_task("simple_test:echo")
    @configuration.should have_run("echo 'test'")
  end

end
