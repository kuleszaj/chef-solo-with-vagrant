# Chef Solo with Vagrant

This repository is an example of the "Chef Solo with Vagrant" pattern that Atomic Object has used for maintaining various servers.

The intent is to provide a skeletal framework from which others can start using the pattern, and also track changes to the pattern itself.

## Requirements

1. [Ruby 1.9.3](http://ruby-lang.org)
2. [Bundler](http://gembundler.com/)
3. [Vagrant](vagrantup.com) 1.1.x or 1.2.x
4. Vagrant Provider (e.g. [VirtualBox](http://virtualbox.org/), [VMWare Fusion](http://www.vagrantup.com/vmware), [AWS](https://github.com/mitchellh/vagrant-aws))

## Getting Started

The following steps will install all necessary gems, boot a new Vagrant, bootstrap chef on the Vagrant, and finally run chef on the Vagrant.

1. Run `bundle install`
1. Run `bundle exec cap vexample vg:up`
1. Run `bundle exec cap vexample bootstrap`
1. Run `bundle exec cap vexample chef`

## Customization

`README` files in each of the repository's directories provide information about the purpose of the directory and included files. Working examples have been provide ("example" and "vexample" stages, and "example_cookbook" cookbook).
