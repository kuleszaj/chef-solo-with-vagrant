# config

The `deploy.rb` file configures Capistrano for our Chef-Solo with Vagrant project.

Custom namespaces/tasks can be defined in `*.rb` files, and placed in the `custom` folder. They will be automatically added.

Servers and their corresponding vagrants are defined in `stages.rb`. All target hosts are a particular 'stage'. By convention, Vagrant hosts start with a 'v'.
