#!/bin/bash

# install latest docker version
sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo bash -c "echo deb https://apt.dockerproject.org/repo ubuntu-$(lsb_release -c | cut -d$'\t' -f 2) main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get purge lxc-docker* docker.io -y
sudo apt-get upgrade -y
sudo apt-get install docker-engine -y
