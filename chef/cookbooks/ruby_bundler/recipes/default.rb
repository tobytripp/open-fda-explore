include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby "2.1.2" do
  global true
end

rbenv_gem "bundler" do
  ruby_version "2.1.2"
end

rbenv_execute "bundle" do
  cwd "/vagrant"
  ruby_version "2.1.2"
end
