#!/usr/bin/env bash


export DEBIAN_FRONTEND=noninteractive

ntpdate ntp.ubuntu.com

echo '---------- APT update & upgrade'

apt-get update 
apt-get dist-upgrade -q -y --force-yes 

echo '---------- Install packages I like'
apt-get install -y --force-yes curl git screen vim  zerofree
echo '---------- Install ruby dependency packages'
apt-get install -y --force-yes make g++ build-essential autoconf
apt-get install -y --force-yes nodejs libxml2-dev libsqlite3-dev 
apt-get install -y --force-yes zlib1g zlib1g-dev libyaml-dev libssl-dev 
apt-get install -y --force-yes libgdbm-dev libreadline6 libreadline6-dev 
apt-get install -y --force-yes libpq-dev libffi-dev
apt-get install -y --force-yes libreadline-dev libncurses5-dev

echo '---------- Install ruby 2.1.0 stable'
mkdir ~/tmp
cd ~/tmp
wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.0.tar.gz
tar xvzf ruby-2.1.0.tar.gz
cd ruby-2.1.0 
./configure  --prefix=/usr --docdir=/usr/share/doc/ruby-2.1.0 --enable-shared && make && make install 

#cd && rm -rf ~/tmp/*

#update-alternatives --set ruby /usr/bin/ruby1.9.1
#update-alternatives --set gem /usr/bin/gem1.9.1

#gem install rails --no-ri --no-rdoc
