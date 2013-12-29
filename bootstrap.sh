#!/usr/bin/env bash


export DEBIAN_FRONTEND=noninteractive

echo '---------- APT update & upgrade'

apt-get update 
apt-get dist-upgrade -q -y --force-yes 

echo '---------- Install latest ruby'
apt-get install -y --force-yes curl git screen vim build-essential nodejs \
  libxml2-dev libsqlite3-dev ruby1.9.1 ruby1.9.1-dev zerofree

update-alternatives --set ruby /usr/bin/ruby1.9.1
update-alternatives --set gem /usr/bin/gem1.9.1

gem install rails --no-ri --no-rdoc
