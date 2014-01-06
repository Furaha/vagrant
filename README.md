# Requirements

- [Vagrant](http://docs.vagrantup.com/v2/)
- [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)

# Description

My scripts to build and/or package a basebox.

Packaged vagrant box with:
- Latest precise32
- Latest Virtualbox Guest Additions

Bootstrap script to install:
- ruby 1.9.3 (ubuntu package)
- rails 4 (gem)

This should get you started with local rails 4 development.

You can download a built 32bit box from https://www.dropbox.com/s/rus3bnksldg0fh6/furaha32.box

# Usage

For i386 `vagrant box add precise http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-i386-vagrant-disk1.box` 

For amd64 `vagrant box add precise http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box`

`mkdir <some_project_directory>`

`cd <some_project_directory>`

`git clone https://github.com/arafatm/vagrant_furaha.git .`

`rm -rf .git/`

`vagrant up`

`vagrant ssh`

# Packaging

Only do this if you want to package your own box for distribution

In Vagrantfile, uncomment `cleanup.sh`

`vagrant reload --provision && vagrant halt`

*Note* On windows you want to add the VBobxManage.exe instead
of vboxmanage. To make it easier, `set PATH=%PATH%;C:\Program
Files\Oracle\VirtualBox` 

`vboxmanage clonehd <disk file>.vmdk <disk file>.vdi --format VDI`

`vboxmanage modifyhd --compact <disk file>.vdi`

In VirtualBox, click on `settings` for your machine and under
`Storage`, point the machine at the new vdi created above.

In VirtualBox, start the virtual machine into `recovery` mode -> `root` mode
and do:
- umount /dev/sda1
- zerofree /dev/sda1

`vagrant package` should create a box file for you to use 

# Credit

Thanks to http://vmassuchetto.github.io/2013/08/14/reducing-a-vagrant-box-size/
for showing me how it's done
