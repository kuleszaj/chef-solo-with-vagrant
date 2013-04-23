# deploy

This folder contains Capistrano stages for use with Capistrano Multi-stage

Each stage is very basic,and follows this pattern:

## Production:

```
server "#{stage}", :chef, :no_release => :true
set :server_ip, "#{stage}"
before "multistage:ensure","warning:warning"
```

## Vagrant/Staging:

```
server "#{stage}", :chef, :no_release => :true
set :server_ip, "#{stage}"
```
