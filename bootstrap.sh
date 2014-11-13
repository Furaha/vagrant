#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt_update

install_ruby
install_postgresql

apt_clean

msg() {
  echo "----------"
  echo "----------"
  echo "---------- $1"
}

apt_update() {
  ntpdate ntp.ubuntu.com

  msg "APT update & upgrade"

  apt-get update 
  apt-get dist-upgrade -q -y --force-yes 

  msg "Install packages I like"
  apt-get install -y --force-yes curl git screen vim  zerofree

  msg "Install ruby build dependency packages"
  apt-get install -y --force-yes make g++ build-essential autoconf
  apt-get install -y --force-yes nodejs libxml2-dev libsqlite3-dev 
  apt-get install -y --force-yes zlib1g zlib1g-dev libyaml-dev libssl-dev 
  apt-get install -y --force-yes libgdbm-dev libreadline6 libreadline6-dev 
  apt-get install -y --force-yes libpq-dev libffi-dev
  apt-get install -y --force-yes libreadline-dev libncurses5-dev

}
apt_clean() {
  msg "APT clean"
  apt-get -y autoremove
  apt-get -y clean
  apt-get autoclean -y

  msg "Clean up ruby build tmp dir"
  cd && rm -rf ~/tmp/*

}

install_ruby() {
  if ! command -v rbenv >/dev/null 2>&1; then
    msg "installing rbenv"

    # node.js (needed for rails_
    if [[ ! -f /etc/apt/sources.list.d/chris-lea* ]]; then 
      sudo add-apt-repository ppa:chris-lea/node.js
    fi

    msg "base utils"
    sudo apt-get update
    sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev \
      libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev \
      libxslt1-dev libcurl4-openssl-dev python-software-properties nodejs

    msg "rbenv"
    /usr/bin/git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv

    msg "rbenv: ruby-build"
    /usr/bin/git clone git://github.com/sstephenson/ruby-build.git \
      $HOME/.rbenv/plugins/ruby-build

    msg "rbenv: rbenv-gem-rehash"
    git clone https://github.com/sstephenson/rbenv-gem-rehash.git \
      $HOME/.rbenv/plugins/rbenv-gem-rehash

    msg "latest ruby"
    LATEST=`rbenv install -l | grep '^\s*2.' | grep -v dev | sort | tail -n 1`

    CONFIGURE_OPTS="--disable-install-doc" rbenv install $LATEST 
    rbenv global  $LATEST
    rbenv rehash

    source $HOME/.bashrc

    msg "Install rails gem"
    gem install rails --no-ri --no-rdoc
  else
    msg "rbenv already installed"
  fi

}

install_postgresql() {

  msg "postgresql"

  if [ ! -f /etc/apt/sources.list.d/pgdg.list ]; then 
    sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ \
      $(lsb_release -sc)-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
    wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | \
      sudo apt-key add -
    sudo apt-get update
    sudo apt-get install postgresql-common postgresql-9.3 libpq-dev

    msg "enter a postgresql username"
    read name

    sudo -u postgres createuser $name --createdb --pwprompt

    msg "Don't forget to set postgres password -"
    msg "  sudo -u postgres psql"
    msg "  postgres=# \password password"
  fi
}
