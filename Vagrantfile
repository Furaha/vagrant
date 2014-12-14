# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. 
# Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

unless Vagrant.has_plugin?("vagrant-vbguest")
  system("vagrant plugin install vagrant-vbguest")
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Either use i386 or amd64 versions
  config.vm.box       = 'ubuntu/trusty32'

  config.vm.hostname  = 'vm'
  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end

  # args:
  #   1 user to copy dotfiles
  #   2 ruby version to install
  config.vm.provision :shell, :path => "bootstrap.sh", 
    :args => [ENV['USER'], '2.1.5' ], privileged: false
end
