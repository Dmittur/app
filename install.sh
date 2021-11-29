#!/bin/bash
sudo ufw disable
sudo apt update
sudo apt-get update && apt-get upgrade -y
sudo apt full-upgrade -y
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
cat /proc/sys/vm/swappiness
sudo echo 'vm.swappiness=25' >> /etc/sysctl.conf
#Time
sudo apt install ntpsec
sudo service ntpsec restart
#iptables
sudo iptables -A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -m hashlimit --hashlimit 1/hour --hashlimit-burst 2 --hashlimit-mode srcip --hashlimit-name SSH --hashlimit-htable-expire 60000 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 22 --tcp-flags SYN,RST,ACK SYN -j DROP
sudo iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
sudo apt install iptables-persistent -y
sudo service netfilter-persistent save
sudo iptables -L -n --line-numbers
sudo apt-get install zip unzip screen wget -y
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
sudo ufw reload
ulimit -n 200000
sudo wget https://github.com/idena-network/idena-web/archive/refs/heads/master.zip
unzip master.zip
wget https://github.com/rioda-org/idena/raw/main/node-v16.13.0-linux-x64.tar.xz
sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xJvf node-v16.13.0-linux-x64.tar.xz -C /usr/local/lib/nodejs
rm node-v16.13.0-linux-x64.tar.xz
echo "export PATH=/usr/local/lib/nodejs/node-v16.13.0-linux-x64/bin:$PATH" >> ~/.profile
. ~/.profile
sudo echo 'deb http://nginx.org/packages/ubuntu/ bionic nginx' | sudo tee -a /etc/apt/sources.list.d/nginx.list
sudo echo 'deb-src http://nginx.org/packages/ubuntu/  bionic nginx' | sudo tee -a /etc/apt/sources.list.d/nginx.list
sudo wget --quiet http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt update
sudo apt install nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
