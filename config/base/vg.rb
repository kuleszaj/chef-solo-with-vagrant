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
      system("vagrant up")
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
