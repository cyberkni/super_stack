#!/bin/bash
SYS_PKGS="build-essential zlib1g zlib1g-dev libxml2 libxml2-dev libxslt-dev \
sqlite3 libsqlite3-dev locate git-core curl wget openssh-server openssh-client\
ufw"
RUBY_PKGS="ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 \
libruby1.8 libopenssl-ruby rubygems libopenssl-ruby"
SERVICE_PKGS="libapache2-mod-passenger apache2 apache2-utils mysql-common \
mysql-server libmysql-ruby apache2-prefork-dev"
RUBY_GEMS="rake rack rails"
PUBLIC_SERVICES="ssh http https"

# Install system packages
apt-get update
apt-get -y install $PKGS $RUBY_PKGS $SERVICE_PKGS

# Install rubygems
gem sources -a http://gems.github.com
gem install $RUBY_GEMS -q -y

# Configure firewall
# Allows services/ports defined in PUBLIC_SERVICES and then defaults to deny
for svc in $PUBLIC_SERVICES; do
  ufw allow $svc
done
ufw default deny