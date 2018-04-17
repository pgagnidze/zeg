class { 'apache':
  mpm_module => 'prefork',
}
include apache::mod::php

class { 'mysql::server': }

class { 'zabbix::agent':
  server               => '127.0.0.1',
  zabbix_version       => '3.4',
  manage_repo          => true,
  zabbix_package_state => 'latest',
}

class { 'zabbix':
  zabbix_url    => 'zabbix.zeg',
  database_type => 'mysql',
}

if $facts['selinux'] {
  selboolean { ['httpd_can_network_connect', 'httpd_can_network_connect_db']:
    persistent => true,
    value      => 'on',
  }
}
