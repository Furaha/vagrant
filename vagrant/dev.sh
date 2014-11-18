user=$1

msg() {
  echo " "
  echo "*****************************************************************"
  echo "*****************************************************************"
  echo "$1"
}

install_ruby() {
  mkdir $HOME/tmp
  cd $HOME/tmp

  wget -O ruby-install-0.5.0.tar.gz \
    https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz
  tar -xzvf ruby-install-0.5.0.tar.gz
  cd ruby-install-0.5.0/
  sudo make install

  ruby-install ruby # install latest stable version
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

install_ruby
install_dotfiles
