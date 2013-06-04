# SSH Namespace
namespace :ssh do
  desc "Create SSH configuration file for {stage} (Vagrant only)."
  # This is only useful for Vagrant stages -- it will not work for any Production stages
  task :generate_config do
    puts "Generating #{ssh_d}/#{stage}_ssh_config..."
    # Create the `ssh_d` directory if it doesn't already exist.
    system("mkdir -p #{ssh_d}")
    # Use Vagrant to generate the SSH config
    system("vagrant ssh-config #{stage} > #{ssh_d}/#{stage}_ssh_config")
  end

  desc "Destroy SSH configuration file for {stage} (Vagrant only)."
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

  desc "SSH into the system specified by {stage} using its SSH configuration file."
  task :default do
    system("ssh -F #{ssh_d}/#{stage}_ssh_config #{stage}")
  end

  desc "Install repository SSH configuration files (production servers) to your global SSH configuration directory (#{ssh_d})."
  task :install do
    system("cp -r config/ssh_configs/* #{ssh_d}")
  end

end
