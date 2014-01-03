#!/bin/sh
# Copied from
# http://vmassuchetto.github.io/2013/08/14/reducing-a-vagrant-box-size/

echo "\n\n----------# Unmount /vagrant"
umount /vagrant

echo "\n\n----------# Remove APT files"
find /var/lib/apt -type f | xargs rm -f

echo "\n\n----------# Remove documentation files"
find /var/lib/doc/* -type f | xargs rm -f
rm -rf /usr/share/doc

echo "\n\n----------# Remove Virtualbox specific files"
rm -rf /usr/src/vboxguest* /usr/src/virtualbox-ose-guest*

echo "\n\n----------# Remove Linux headers"
rm -rf /usr/src/linux-headers*

echo "\n\n----------# Remove Unused locales"
rm -rf /usr/share/locale/*

echo "\n\n----------# Clean cache"
find /var/cache -type f -exec rm -rf {} \;

echo "\n\n----------# Remove bash history"
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

echo "\n\n---------# Cleanup log files"
find /var/log -type f | while read f; do echo -ne '' > $f; done;

echo "\n\n------------------------------\n"
echo "The following steps are manual."
echo "Using Virtualbox, boot into 'recovery' -> 'root' mode and run:"
echo "  - umount /dev/sda1"
echo "  - zerofree -v /dev/sda1"
echo "\n\nNote: On windows, add the path to vboxmanage:\nset PATH=%PATH%;C:\\Program Files\\Oracle\\VirtualBox"
echo "\nThen find the vmdk used to compact as vdi prior to packaging:"
echo "  vboxmanage clonehd <disk file>.vmdk <disk file>.vdi --format VDI"
echo "  vboxmanage modifyhd --compact <disk file>.vdi"
echo "\nUsing Virtualbox, point the disk at the new vdi created then"
echo "  vagrant package" 
echo "\nYou should now have a *.box file that you can distribute"
