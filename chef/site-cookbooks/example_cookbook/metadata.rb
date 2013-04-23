name              "example_cookbook"
maintainer        "Atomic Object, LLC"
maintainer_email  "admin@atomicobject.com"
license           "BSD"
description       "Ensures chef configuration is operational."
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"

recipe "default", "Creates directory and file in user's home directory"

%w{ debian ubuntu centos redhat scientific fedora amazon arch freebsd }.each do |os|
    supports os
end
