#!/usr/bin/env ruby

namespace :simple_example do
  desc "This is an example task"
  task :default do
    system(%q|echo "I don't do anything!"|)
  end
end
