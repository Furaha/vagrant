#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

msg() {
  echo "*"
  echo "*"
  echo "*****************************************************************"
  echo "*****************************************************************"
  echo "$1"
}
apt() {
  apt-get install -y --force-yes $1
}

apt_3rd_party() {
  # node.js  repo
  if [[ ! -f /etc/apt/sources.list.d/chris-lea* ]]; then 
    msg "adding node.js repo"
    add-apt-repository ppa:chris-lea/node.js
  fi

  # postgresql repo
  if [ ! -f /etc/apt/sources.list.d/pgdg.list ]; then 
    msg "adding postgresql repo"
    sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ \
      $(lsb_release -sc)-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
    wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | \
      apt-key add -
  fi
}

apt_upgrade() {
  msg "APT update & upgrade"

  ntpdate ntp.ubuntu.com

  apt-get update
  apt-get dist-upgrade -q -y --force-yes 
}

apt_core() {

  pkgs="curl git screen tmux vim zerofree"
  pkgs="$pkgs zlib1g-dev build-essential libssl-dev libreadline-dev"
  pkgs="$pkgs libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev" 
  pkgs="$pkgs libcurl4-openssl-dev python-software-properties nodejs"

  msg "install pkgs"
  echo "$pkgs"
  apt "$pkgs"
}

postgres() {
  msg "postgresql"
  apt "postgresql-9.3 libpq-dev"
  sudo -u postgres createuser vagrant -s
}

apt_clean() {
  msg "APT clean"
  apt-get -y autoremove
  apt-get -y clean
  apt-get autoclean -y
}

apt_3rd_party
apt_upgrade
apt_core
postgres
apt_clean
