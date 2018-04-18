class { 'docker':
  use_upstream_package_source => false,
  repo_opt                    => '',
  service_overrides_template  => false,
  docker_ce_package_name      => 'docker',
  version                     => 'latest',
  dns                         => '1.1.1.1',
}

group { 'docker':
  ensure => 'present',
}

docker_network { 'zabnet':
  ensure => present,
  driver => 'bridge',
}

docker::image { 'mysql':
  image_tag => 'latest'
}

docker::image { 'zabbix/zabbix-server-mysql':
  image_tag => 'latest'
}

docker::image { 'zabbix/zabbix-web-nginx-mysql':
  image_tag => 'latest'
}

docker::image { 'zabbix/zabbix-agent':
  image_tag => 'latest'
}

docker::run { 'mysql-server':
  image => 'mysql:latest',
  env   => ['MYSQL_ROOT_PASSWORD=root',
            'MYSQL_USER=zabbix',
            'MYSQL_PASSWORD=zabbix',],
  net   => 'zabnet',
}

docker::run { 'zabbix-server':
  image => 'zabbix/zabbix-server-mysql:latest',
  env   => ['MYSQL_ROOT_PASSWORD=root'],
  ports => ['10051:10051'],
  links => ['mysql-server:mysql-server'],
  net   => 'zabnet',
}

docker::run { 'zabbix-web':
  image => 'zabbix/zabbix-web-nginx-mysql:latest',
  env   => ['MYSQL_ROOT_PASSWORD=root'],
  ports => ['80:80'],
  links => ['zabbix-server:zabbix-server'],
  net   => 'zabnet',
}

docker::run { 'zabbix-agent':
  image      => 'zabbix/zabbix-agent:latest',
  env        =>  ['ZBX_HOSTNAME="zabbix-server"',
                  'ZBX_SERVER_HOST="zabbix-server"'],
  ports      => ['10050:10050'],
  links      => ['zabbix-server:zabbix-server'],
  privileged => true,
  net        => 'zabnet',
}
