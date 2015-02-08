#!/usr/bin/env bash 

set -e

export DEBIAN_FRONTEND=noninteractive 

USER=

if [[ -z $1 ]]; then
  USER=arafatm
else
  USER=$1
fi

INSTALLED=

msg() { echo "*" echo "*"
  echo "*****************************************************************"
  echo "*****************************************************************"
  echo "$1"
}

apt() {
  sudo apt-get install -y --force-yes $1
}

apt_3rd_party() {
  # node.js  repo
  if [ ! -f /etc/apt/sources.list.d/chris-lea*.list ]; then 
    msg "adding node.js repo"
    sudo add-apt-repository ppa:chris-lea/node.js
  fi

  # Using system postgresql
  # postgresql repo
  #if [ ! -f /etc/apt/sources.list.d/pgdg.list ]; then 
  #  msg "adding postgresql repo"
  #  sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ \
    #    $(lsb_release -sc)-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
  #  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | \
    #    sudo apt-key add -
  #fi
}

apt_upgrade() {

  if [ "$[$(date +%s) - $(stat -c %Z /var/lib/apt/periodic/update-success-stamp)]" -ge 3600 ]; then
    msg "APT update & upgrade"
    sudo ntpdate ntp.ubuntu.com
    sudo apt-get update
    sudo apt-get dist-upgrade -q -y --force-yes 
    INSTALLED="$INSTALLED apt-upgrade"
  fi
}

apt_core() {

  pkgs="curl git screen tmux vim zerofree"
  pkgs="$pkgs zlib1g-dev build-essential libssl-dev libreadline-dev"
  pkgs="$pkgs libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev" 
  pkgs="$pkgs libcurl4-openssl-dev python-software-properties nodejs"
  pkgs="$pkgs imagemagick libmagickwand-dev"

  msg "install pkgs"
  apt "$pkgs"
}

apt_clean() {
  msg "APT clean"
  sudo apt-get -y autoremove
  sudo apt-get -y clean
  sudo apt-get autoclean -y
}

install_postgres() {
  msg "postgresql"
  apt "postgresql-9.3 libpq-dev postgresql-server-dev-9.3 postgresql-contrib-9.3"

  # install pgcrypto module
  if [[ ! $(sudo -u postgres psql template1 -c '\dx') =~ pgcrypto ]]; then
    sudo -u postgres psql template1 -c 'create extension pgcrypto'
  fi

  # Add rails user with createdb
  if [[ ! $(sudo -u postgres psql template1 -c '\du') =~ rails ]]; then
    sudo -u postgres psql -c \
      "create user rails with createdb password 'railspass'"
  fi

  sudo sh -c "echo \"local all postgres  peer\nlocal all all       md5\" \
    > /etc/postgresql/9.3/main/pg_hba.conf" 

  INSTALLED="$INSTALLED postgres"
}

install_rbenv() {
  if [ ! `which rbenv` ]; then
    msg "installing rbenv"
    git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv

    msg "rbenv: ruby-build"
    git clone git://github.com/sstephenson/ruby-build.git \
      $HOME/.rbenv/plugins/ruby-build

    msg "rbenv: rbenv-gem-rehash"
    git clone https://github.com/sstephenson/rbenv-gem-rehash.git \
      $HOME/.rbenv/plugins/rbenv-gem-rehash
  else
    msg "updating ruby version"
  fi

  msg "latest ruby"

  rbenv=$HOME/.rbenv/bin/rbenv

  #LATEST=`$rbenv install -l | grep '^\s*2.1.*' | grep -v dev | sort | tail -n 1`
  #LATEST='2.1.5'

  # Install a ruby
  # if [[ ! $(ruby -v) =~ "ruby $LATEST" ]]; then 
  #   CONFIGURE_OPTS="--disable-install-doc" $rbenv install -v $LATEST 
  #   $rbenv global  $LATEST
  #   $rbenv rehash
  # else
  #   echo "ruby $LATEST already installed"
  # fi

  INSTALLED="$INSTALLED rbenv"
}

install_dotfiles() {
  msg "Installing $USER dotfiles"
  if [[ ! -d $HOME/dotfiles ]]; then 
    msg "installing dotfiles" 
    git clone https://github.com/$USER/dotfiles.git $HOME/dotfiles
    bash $HOME/dotfiles/setup.dotfiles.sh
  else
    msg "updating dotfiles" 
    cd $HOME/dotfiles
    git pull
  fi
  INSTALLED="$INSTALLED dotfiles"
}

congrats() {
  echo "Install complete"
}

apt_3rd_party
apt_upgrade
apt_core

install_postgres
install_rbenv
install_dotfiles

apt_clean
