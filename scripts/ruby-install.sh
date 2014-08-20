#!/bin/sh

RUBY_VERSION=2.1.2
RUBY_NAME=ruby-${RUBY_VERSION}
RUBY_TAR=${RUBY_NAME}.tar.gz

sudo apt-get -y update
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev

cd /tmp
wget http://cache.ruby-lang.org/pub/ruby/2.1/${RUBY_TAR}
tar -xvzf ${RUBY_TAR}

cd $RUBY_NAME

./configure --prefix=/usr/local
make
sudo make install

sudo gem install chef ohai --no-rdoc --no-ri
