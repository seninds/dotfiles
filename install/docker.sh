#!/bin/sh

apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
DOCKER_LIST="/etc/apt/sources.list.d/docker.list"
echo deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -c | cut -f2) main | tee "$DOCKER_LIST"
apt-get update
apt-get install -y docker-engine

curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
