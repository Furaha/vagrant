#!/usr/bin/env bash

if [ ! -e "/home/vagrant/.firstboot" ]; then
  export DEBIAN_FRONTEND=noninteractive

  echo '---------- APT update & upgrade'

  apt-get update 
  apt-get dist-upgrade -q -y --force-yes 

  echo '---------- Install latest ruby'
  apt-get install -y --force-yes curl git screen vim build-essential nodejs \
    libxml2-dev libsqlite3-dev ruby1.9.1 ruby1.9.1-dev
  gem install rails --no-ri --no-rdoc

  echo '---------- APT clean'
  apt-get -y autoremove
  apt-get -y clean
  touch /home/vagrant/.firstboot
fi
