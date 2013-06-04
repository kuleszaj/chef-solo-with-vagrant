# Berks Namespace
namespace :berks do
  desc "Vendorize cookbooks from the Berksfile into chef/cookbooks"
  task :default do
    system("berks install --path chef/cookbooks/")
  end
end
