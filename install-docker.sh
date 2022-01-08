#!/bin/bash

DVERSION=$(docker --version | grep version)

if ! command -v docker > /dev/null ; then
  echo "DOCKER DOES NOT EXIST"
    sleep 2 && clear
  echo "INSTALLING DOCKER..."
    sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg |\
    sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io
  echo "SETTING DOCKER GROUP AND PERMISSIONS"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
    sudo chmod 666 /var/run/docker.sock
  echo "PREPARING DOCKER"
    sudo systemctl enable docker
    sudo systemctl daemon-reload
    sudo systemctl restart docker
else
  echo "DOCKER FOUND, EXITING"
  sleep 2
exit 1
fi
