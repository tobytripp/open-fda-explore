remote_file "/usr/local/bin/lein" do
  source "https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein"
  mode 0755
  owner "root"
  group "root"
end

execute "install leiningen" do
  command "lein version"
  user  node[:leiningen][:user]
  group node[:leiningen][:group]
  environment "HOME" => node[:leiningen][:home]
end
