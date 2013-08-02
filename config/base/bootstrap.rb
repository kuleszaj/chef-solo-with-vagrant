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
      system("cd chef && knife bootstrap --bootstrap-version '#{chef_version}' -d chef-solo -x #{user} -i #{id_file} --sudo #{hostname} -p #{hostport}")
    else
      system("cd chef && knife bootstrap --bootstrap-version '#{chef_version}' -d chef-solo -x #{user} --sudo #{hostname} -p #{hostport}")
    end
  end
end
