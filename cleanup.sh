#!/bin/sh
# Copied from
# http://vmassuchetto.github.io/2013/08/14/reducing-a-vagrant-box-size/

echo '----------# Unmount /vagrant'
umount /vagrant

echo '---------- APT clean'
apt-get -y autoremove
apt-get -y clean
apt-get autoclean -y

echo '----------# Remove APT files'
find /var/lib/apt -type f | xargs rm -f

echo '----------# Remove documentation files'
find /var/lib/doc/* -type f | xargs rm -f
rm -rf /usr/share/doc

echo '----------# Remove Virtualbox specific files'
rm -rf /usr/src/vboxguest* /usr/src/virtualbox-ose-guest*

echo '----------# Remove Linux headers'
rm -rf /usr/src/linux-headers*

echo '----------# Remove Unused locales'
rm -rf /usr/share/locale/*

echo '----------# Clean cache'
find /var/cache -type f -exec rm -rf {} \;

echo '----------# Remove bash history'
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

echo '---------# Cleanup log files'
find /var/log -type f | while read f; do echo -ne '' > $f; done;

echo -e "\n------------------------------\n"
echo -e "boot into 'root' mode and run the following:"
echo -e "  - umount /dev/sda1"
echo -e "  - zerofree -v /dev/sda1"
echo -e "\nThen compact the vdi prior to packaging:"
echo -e "  vboxmanage clonehd <disk file>.vmdk <disk file>.vdi --format VDI"
echo -e "  vboxmanage modifyhd --compact <disk file>.vdi"
echo -e "  vagrant package --base <machine name>"
echo 'On windows, the path to vboxmanage is "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"'
