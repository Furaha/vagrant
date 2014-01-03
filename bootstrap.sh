#!/usr/bin/env bash


export DEBIAN_FRONTEND=noninteractive

ntpdate ntp.ubuntu.com

echo "\n\n---------- APT update & upgrade"

apt-get update 
apt-get dist-upgrade -q -y --force-yes 

echo "\n\n---------- Install packages I like"
apt-get install -y --force-yes curl git screen vim  zerofree
echo "\n\n---------- Install ruby build dependency packages"
apt-get install -y --force-yes make g++ build-essential autoconf
apt-get install -y --force-yes nodejs libxml2-dev libsqlite3-dev 
apt-get install -y --force-yes zlib1g zlib1g-dev libyaml-dev libssl-dev 
apt-get install -y --force-yes libgdbm-dev libreadline6 libreadline6-dev 
apt-get install -y --force-yes libpq-dev libffi-dev
apt-get install -y --force-yes libreadline-dev libncurses5-dev

echo "\n\n---------- APT clean"
apt-get -y autoremove
apt-get -y clean
apt-get autoclean -y

echo "\n\n---------- Install ruby 2.1.0 stable"
mkdir ~/tmp
cd ~/tmp
wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.0.tar.gz
tar xvzf ruby-2.1.0.tar.gz
cd ruby-2.1.0 
./configure  --prefix=/usr --docdir=/usr/share/doc/ruby-2.1.0 --enable-shared && make && make install 

echo "\n\n---------- Clean up ruby build tmp dir"
cd && rm -rf ~/tmp/*


echo "\n\n---------- Install rails gem"
gem install rails --no-ri --no-rdoc

