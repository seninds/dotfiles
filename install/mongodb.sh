#!/bin/sh

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
MONGODB_LIST="/etc/apt/sources.list.d/mongodb-org-3.0.list"
echo "deb http://repo.mongodb.org/apt/ubuntu $(lsb_release -c | cut -f2)/mongodb-org/3.0 multiverse" | tee "$MONGODB_LIST"
apt-get update
apt-get install -y mongodb-org
