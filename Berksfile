# -*- mode: ruby -*-
source "https://api.berkshelf.com"

cookbook 'build-essential', '~> 2.0.2'

group :jvm do
  cookbook "java"
  cookbook "datomic", github: "hectcastro/chef-datomic", ref: "0.2.0"
  cookbook "leiningen", path: "./chef/cookbooks/leiningen"
end

group :ruby do
  cookbook "ruby_bundler", path: "./chef/cookbooks/ruby_bundler"
end
