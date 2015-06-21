#!/bin/bash

node="$1"
if [ "$node" = "" ];
then
    echo "Usage: $0 node"
    exit 1
fi

if !(command -v chef-solo &> /dev/null);
then
    apt-get update
    apt-get install -y ruby1.9.1 ruby1.9.1-dev build-essential
    gem1.9.1 install chef --no-rdoc --no-ri --version="11.6.2"
fi

patch cookbooks/mysql-multi/recipes/mysql_master.rb mysql-master-pass-fix.diff
patch cookbooks/mysql-multi/recipes/default.rb mysql-default-bind-fix.diff
chef-solo -c solo.rb -j "nodes/${node}.json" &&
service mysql restart
#apt-get install mysql-utilities -y
