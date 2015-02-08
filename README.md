
# QuickStart


`wget -qO- https://github.com/Furaha/vagrant/archive/latest.tar.gz | tar xvz --strip 1 && vagrant up`

This create the vagrantfile and bootstrap script to create your new vagrant box

NOTE: If the `vagrant up` fails at some point (shouldn't happen, but murphy):
- vagrant ssh
- cd to the directory with bootstrap.sh (probably /vagrant)
- run `bash bootstrap.sh`.
This should continue from the last error.

## Ruby/Rails project

To create a new rails project (or clone an existing one), follow these steps
- vagrant ssh
- Either `mkdir <project>` or `cd <project>` if it exists
- If you don't have a `ruby_version` file, then `rbenv install <version>`
- Make sure you have the right ruby version installed `rbenv versions`
- `rbenv install <version>` if you need to
- Check `ruby -v` to ensure you're using the right ruby version
- `gem install bundler` if you just did an rbenv install
- Generate a Gemfile if you don't have one yet
- `binit` to install the gems required for this project
- `b rake db:create` to make sure that the rails project can create the databases

Have fun!

NOTE: `DO NOT USE SYSTEM RUBY/GEMS`. Use `b <command>` to make sure you're
always using the project's ruby/gems. e.g. `b rspec spec/`

NOTE: Using `binit` allows you package the project's gems so you're always
using the right version. See
http://ryan.mcgeary.org/2011/02/09/vendor-everything-still-applies/ for more
info

NOTE: To see what `binit` does, type `alias binit`. This is defined in
`~/.bash/aliasesdev` which is installed when cloning my dotfiles as part of the
bootstrap. To see what `bundle_init` does, type `type bundle_init`.

# What Is Included

## Ruby version

Your project folder root should have a `.ruby_version` file that specified the
version this project uses.

e.g. `2.1.5`

If you don't have the file, you can use `rbenv local 2.1.5` to generate it.

Make sure that rbenv has that version installed by checking `rbenv versions`.
To install a specific version, do `rbenv install 2.1.5`. Check `rbenv install
-l` to see what versions are available for install.

## Postgresql

Postgresql 9.3 is installed by default.

Also creates a `rails` user that can be used in your rails
`config/database.yaml` to create/manage your rails DB.

## dotfiles

Provisioner git clones `https://github.com/$user/dotfiles` and runs `bash
setup.dotfiles.sh`.

If `$user` is not defined in the `Vagranfile` then the default repo it clones is `arafatm/dotfiles`.

If using `arafatm/dotfiles`, take a look at `home/.bash/aliasesdev` to see some
default aliases I have defined

While I created most of the aliases in  http://ryan.mcgeary.org/2011/02/09/vendor-everything-still-applies/ , I made a few changes. Take a look at `~/dotfiles/home/.bash/aliasesdev` to see my changes.

## ssh

Note that my dotfiles expect that you're using ssh-agent either on the host with ssh.agent.forwarding or on the guest directly after copying your ssh keys.

I recommend the first option so you only have to run it on the host.

See https://developer.github.com/guides/using-ssh-agent-forwarding/ for more info. 

NOTE: This means I recommend you use the ssh clone URL instead of the HTTPS clone URL. 


# Old Shit. Ignore

## Description

My scripts to build and/or package a basebox.

Packaged vagrant box with:
- Latest precise32
- Latest Virtualbox Guest Additions

Bootstrap script to install:
- ruby 2.1.0
- rails 4.0.2

This should get you started with local rails 4 development.

You can download a built 32bit box from https://www.dropbox.com/s/zrvr0ppv24m6cxg/furaha32.ruby.2.1.0.rails.4.0.2.box

## Usage

For i386 `vagrant box add cloud32 http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-i386-vagrant-disk1.box` 

For amd64 `vagrant box add cloud64 http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box`

`mkdir <some_project_directory>`

`cd <some_project_directory>`

`git clone https://github.com/arafatm/vagrant_furaha.git .`

`rm -rf .git/`

`vagrant up`

`vagrant ssh`

## Packaging

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

## Note on GuestAdditions

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

## Credit

Thanks to http://vmassuchetto.github.io/2013/08/14/reducing-a-vagrant-box-size/
for showing me how it's done
