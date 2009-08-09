#!/bin/bash
if [ -z $1 ]; then
  echo "Please provide a domain name to build for."
  exit -1
fi
domain=$1
if [ -z $2 ]; then
  echo "Please provide a git repo to use."
  exit -1
fi
git_repo=$2
SYS_PKGS="build-essential zlib1g zlib1g-dev libxml2 libxml2-dev libxslt-dev \
sqlite3 libsqlite3-dev locate git-core curl wget openssh-server openssh-client \
ufw vim"
RUBY_PKGS="ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 \
libruby1.8 libopenssl-ruby rubygems libopenssl-ruby"
SERVICE_PKGS="libapache2-mod-passenger apache2 apache2-utils mysql-common \
mysql-server libmysql-ruby apache2-prefork-dev"
RUBY_GEMS="rake rack rails"
PUBLIC_SERVICES="ssh http https"

# Install system packages
apt-get update
apt-get -y install $SYS_PKGS $RUBY_PKGS $SERVICE_PKGS

# Install rubygems
gem sources -a http://gems.github.com
gem install $RUBY_GEMS -q -y

# Configure firewall
# Allows services/ports defined in PUBLIC_SERVICES and then defaults to deny
ufw enable
for svc in $PUBLIC_SERVICES; do
  ufw allow $svc
done
ufw default deny

# Drop configuration templates for apache
# 1) configure passenger - done by ubuntu
# 2) configure vhost using passenger - needs to be done
if [ ! -d /var/app/ ]; then
  mkdir -p /var/app/
fi
cd /var/app/
git clone ${git_repo} ${domain}
sudo chown www-data:www-data /var/app/${domain}/config/environment.rb
sudo echo "<VirtualHost *:80>
    ServerName ${domain}
    DocumentRoot /var/app/${domain}/public
</VirtualHost>" >> /etc/apache2/sites-available/${domain}
a2ensite ${domain}
/etc/init.d/apache2 restart