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
