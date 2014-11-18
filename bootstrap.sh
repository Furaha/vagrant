#!/usr/bin/env bash 

export DEBIAN_FRONTEND=noninteractive 
user=$1

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

  sudo apt-get update
  sudo apt-get dist-upgrade -q -y --force-yes 
}

apt_core() {

  pkgs="curl git screen tmux vim zerofree"
  pkgs="$pkgs zlib1g-dev build-essential libssl-dev libreadline-dev"
  pkgs="$pkgs libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev" 
  pkgs="$pkgs libcurl4-openssl-dev python-software-properties nodejs"
  pkgs="$pkgs imagemagick libmagickwand-dev"

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
  sudo apt-get -y autoremove
  sudo apt-get -y clean
  sudo apt-get autoclean -y
}

install_ruby() {
  if ! command -v rbenv >/dev/null 2>&1; then
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
  LATEST='2.1.5'

  if [[ ! $(ruby -v) =~ "ruby $LATEST" ]]; then 
    CONFIGURE_OPTS="--disable-install-doc" $rbenv install -v $LATEST 
    $rbenv global  $LATEST
    $rbenv rehash
  else
    echo "ruby $LATEST already installed"
  fi
}

install_dotfiles() {
  msg "Installing $user dotfiles"
  if [[ ! -d $HOME/dotfiles ]]; then 
    msg "installing dotfiles" 
    git clone https://github.com/$user/dotfiles.git $HOME/dotfiles
    bash $HOME/dotfiles/setup.dotfiles.sh
  else
    msg "updating dotfiles" 
    cd $HOME/dotfiles
    git pull
  fi
}

bundle_install() {
  cd /vagrant
  bundle install
}

#apt_3rd_party
#apt_upgrade
#apt_core
#postgres
#apt_clean
#
#install_ruby
install_dotfiles
