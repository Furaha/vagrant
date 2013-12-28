# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'furaha'
  config.vm.hostname = 'furaha'

  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provision :shell, :path => "bootstrap.sh"

  # Clean up box when packaging
  # config.vm.provision :shell, :path => "cleanup.sh"
end
