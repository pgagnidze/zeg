#!/bin/bash

sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
sudo yum -y install puppet-agent
sudo yum -y install git

if [ -d "$HOME/zeg" ]; then
  cd $HOME/zeg && git reset --hard && git pull
else
  git clone https://github.com/papungag/zeg.git ~/zeg
fi
  
sudo mv $HOME/zeg/manifests/* /etc/puppetlabs/code/environments/production/manifests/

sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
sudo /opt/puppetlabs/bin/puppet module install puppetlabs-docker --version 1.1.0
sudo /opt/puppetlabs/bin/puppet apply -v /etc/puppetlabs/code/environments/production/manifests/zabbix.pp