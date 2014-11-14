user=$1

msg() {
  echo " "
  echo "*****************************************************************"
  echo "*****************************************************************"
  echo "$1"
}

install_dotfiles() {
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

install_ruby() {
  if ! command -v rbenv >/dev/null 2>&1; then
    msg "installing rbenv"
    /usr/bin/git clone git://github.com/sstephenson/rbenv.git $HOME/.rbenv

    msg "rbenv: ruby-build"
    /usr/bin/git clone git://github.com/sstephenson/ruby-build.git \
      $HOME/.rbenv/plugins/ruby-build

    msg "rbenv: rbenv-gem-rehash"
    git clone https://github.com/sstephenson/rbenv-gem-rehash.git \
      $HOME/.rbenv/plugins/rbenv-gem-rehash

  else
    msg "updating ruby version"
  fi

  msg "latest ruby"

  rbenv=$HOME/.rbenv/bin/rbenv
  LATEST=`$rbenv install -l | grep '^\s*2.1.*' | grep -v dev | sort | tail -n 1`

  CONFIGURE_OPTS="--disable-install-doc" $rbenv install $LATEST 
  $rbenv global  $LATEST
  $rbenv rehash

}

install_dotfiles
install_ruby
