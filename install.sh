#!/bin/bash
sudo ufw disable
sudo apt update
#Files
sudo echo "DefaultLimitNOFILE=65535" >> /etc/systemd/system.conf
#swap file 4 Gb
sudo swapon --show
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
sudo echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo echo 'vm.swappiness=25' >> /etc/sysctl.conf
#Time
sudo apt install ntpsec
sudo service ntpsec restart
sudo apt-get install zip unzip screen wget -y
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
sudo ufw enable
sudo ufw reload
ulimit -n 200000
wget https://github.com/idena-network/idena-web/archive/refs/heads/master.zip
unzip master.zip && cd idena-web-master
