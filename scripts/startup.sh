#!/bin/bash

sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
sudo yum -y install puppet-agent
sudo yum -y install git

if [ -d "$HOME/zeg" ]; then
  cd $HOME/zeg && git reset --hard && git checkout
fi
else
  git clone https://github.com/papungag/zeg.git
fi
  
sudo mv zeg/manifests/* /etc/puppetlabs/code/environments/production/manifests/

sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
sudo /opt/puppetlabs/bin/puppet module install puppetlabs-docker --version 1.1.0
sudo /opt/puppetlabs/bin/puppet apply -v /etc/puppetlabs/code/environments/production/manifests/zabbix.pp