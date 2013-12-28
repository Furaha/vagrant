#!/bin/sh

# Copied from
# http://vmassuchetto.github.io/2013/08/14/reducing-a-vagrant-box-size/
#
# Credits to:
# - http://vstone.eu/reducing-vagrant-box-size/
# - https://github.com/mitchellh/vagrant/issues/343
# - https://gist.github.com/adrienbrault/3775253
 
if [ ! -e "/home/vagrant/.cleanup" ]; then
  echo '----------# Unmount project'
  umount /vagrant
   
  echo '----------# Remove APT cache'
  apt-get clean -y
  apt-get autoclean -y
   
  echo '----------# Zero free space to aid VM compression'
  dd if=/dev/zero of=/EMPTY bs=1M
  rm -f /EMPTY
   
  echo '----------# Remove APT files'
  find /var/lib/apt -type f | xargs rm -f
   
  echo '----------# Remove documentation files'
  find /var/lib/doc -type f | xargs rm -f
   
  echo '----------# Remove Virtualbox specific files'
  rm -rf /usr/src/vboxguest* /usr/src/virtualbox-ose-guest*
   
  echo '----------# Remove Linux headers'
  rm -rf /usr/src/linux-headers*
   
  echo '----------# Remove Unused locales'
  find /usr/share/locale/{af,am,ar,as,ast,az,bal,be,bg,bn,bn_IN,br,bs,byn,ca,cr,cs,csb,cy,da,de,de_AT,dz,el,en_AU,en_CA,eo,es,et,et_EE,eu,fa,fi,fo,fr,fur,ga,gez,gl,gu,haw,he,hi,hr,hu,hy,id,is,it,ja,ka,kk,km,kn,ko,kok,ku,ky,lg,lt,lv,mg,mi,mk,ml,mn,mr,ms,mt,nb,ne,nl,nn,no,nso,oc,or,pa,pl,ps,qu,ro,ru,rw,si,sk,sl,so,sq,sr,sr*latin,sv,sw,ta,te,th,ti,tig,tk,tl,tr,tt,ur,urd,ve,vi,wa,wal,wo,xh,zh,zh_HK,zh_CN,zh_TW,zu} -type d -delete
   
  echo '----------# Remove bash history'
  unset HISTFILE
  rm -f /root/.bash_history
  rm -f /home/vagrant/.bash_history
   
  echo '---------# Cleanup log files'
  find /var/log -type f | while read f; do echo -ne '' > $f; done;
   
  echo '---------# Whiteout root'
  count=`df --sync -kP / | tail -n1 | awk -F ' ' '{print $4}'`;
  count=$((count -= 1))
  dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
  rm /tmp/whitespace;
   
  echo '---------# Whiteout /boot'
  count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
  count=$((count -= 1))
  dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
  rm /boot/whitespace;
   
  echo '---------# Whiteout swap'
  swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
  swapoff $swappart;
  dd if=/dev/zero of=$swappart;
  mkswap $swappart;
  swapon $swappart;

  touch /home/vagrant/.cleanup
else
  echo '########## .cleanup file found. This script has already been run'
fi
