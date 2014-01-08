# Requirements

- [Vagrant](http://docs.vagrantup.com/v2/)

# Description

My scripts to build and/or package a basebox.

Packaged vagrant box with:
- Latest precise32
- Latest Virtualbox Guest Additions

Bootstrap script to install:
- ruby 2.1.0
- rails 4.0.2

This should get you started with local rails 4 development.

You can download a built 32bit box from https://www.dropbox.com/s/zrvr0ppv24m6cxg/furaha32.ruby.2.1.0.rails.4.0.2.box

# Usage

For i386 `vagrant box add cloud32 http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-i386-vagrant-disk1.box` 

For amd64 `vagrant box add cloud64 http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box`

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

In VirtualBox, start the virtual machine into `recovery` mode -> `root` mode
and do:
- `umount /dev/sda1`
- `zerofree /dev/sda1`
- halt the machine

`vboxmanage modifyhd --compact <disk file>.vdi`

In VirtualBox, click on `settings` for your machine and under
`Storage`, point the machine at the new vdi created above.

`vagrant package` should create a box file for you to use 

# Note on GuestAdditions

I had trouble running `vagrant plugins install vagrant-vbguest` so here's
instructions on how to manually update virtualbox GuestAdditions

`vagrant ssh`

`sudo apt-get purge virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11`

`mkdir tmp`

`wget http://download.virtualbox.org/virtualbox/4.3.6/VBoxGuestAdditions_4.3.6.iso`
make sure this is the version of virtualbox you are running

`sudo mount -o loop VBoxGuestAdditions_4.2.6.iso /mnt`

`cd /mnt`

`sudo ./VBoxLinuxAdditions.run`

`cd && umount /mnt`

`rm -f tmp/*`

`exit`

`vagrant reload --provision`

# Credit

Thanks to http://vmassuchetto.github.io/2013/08/14/reducing-a-vagrant-box-size/
for showing me how it's done
