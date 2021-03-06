# -*- mode: ruby -*-
# vi: set ft=ruby :

## https://docs.vagrantup.com/v2/installation/

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "hashicorp/precise64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 4343, host: 4343

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # $ vagrant plugin install vagrant-berkshelf
  config.berkshelf.enabled = true
  # In order to use the Vagrant-Berkshelf plugin, you must have ChefDK
  # installed.
  # To download the latest ChefDK visit
  # http://getchef.com/downloads/chef-dk.

  # $ vagrant plugin install vagrant-omnibus
  config.omnibus.chef_version = :latest

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  config.vm.provision "chef_solo" do |chef|
    # Berkshelf takes over the cookbook path
    # chef.cookbooks_path = "chef/cookbooks"
    chef.roles_path     = "chef/roles"
    chef.data_bags_path = "chef/data_bags"

    chef.add_recipe "apt"
    chef.add_recipe "build-essential"
    chef.add_recipe "ruby_build"
    chef.add_recipe "git"

    chef.add_role "base"
    chef.add_role "datomic"
    chef.add_role "client"

    chef.json = {
      "datomic" => {
        "license_key"          => ENV.fetch("DATOMIC_LICENSE_KEY")          { "" },
        "license_email"        => ENV.fetch("DATOMIC_LICENSE_EMAIL")        { "" },
        "license_download_key" => ENV.fetch("DATOMIC_LICENSE_DOWNLOAD_KEY") { "" }
      }}
  end
end
