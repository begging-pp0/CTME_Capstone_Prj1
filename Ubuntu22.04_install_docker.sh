#!/bin/bash 
# sudo apt-get purge docker-ce docker-ce-cli containerd.io 
# sudo rm -rf /var/lib/docker
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
sudo add-apt-reposity "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
sudo apt-get install docker-ce 
docker --version 
# sudo docker run hello-world 

