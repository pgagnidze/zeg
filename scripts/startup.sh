#!/bin/bash

sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
sudo yum -y install puppet-agent
sudo yum -y install git
sudo yum -y install python-pip

if [ -d "$HOME/zeg" ]; then
  cd $HOME/zeg && git reset --hard && git pull
else
  git clone https://github.com/papungag/zeg.git
fi

sudo mv $HOME/zeg/manifests/* /etc/puppetlabs/code/environments/production/manifests/

sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
sudo /opt/puppetlabs/bin/puppet module install puppetlabs-docker --version 1.1.0
sudo /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/zabbix.pp

sleep 2m

sudo pip install pyzabbix
sudo pip install lxml
sudo pip install cssselect

mv $HOME/zeg/data/* .
/usr/bin/python add_host.py

crontab -l | { cat; echo "* * * * * /usr/bin/python scrape.py"; } | crontab -
crontab -l | { cat; echo "*/2 * * * * /usr/bin/python add_host.py"; } | crontab -
crontab -l | { cat; echo "*/5 * * * * /usr/bin/python add_item.py"; } | crontab -