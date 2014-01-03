# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. 
# Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Either use i386 or amd64 versions
  config.vm.box       = 'cloud32'
  config.vm.box_url  = 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-i386-vagrant-disk1.box'
  #config.vm.box       = 'cloud64'
  # config.vm.box_url  = 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box'

  config.vm.hostname  = 'vm'
  config.ssh.forward_agent = true

  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.provision :shell, :path => "cleanup.sh"
end
