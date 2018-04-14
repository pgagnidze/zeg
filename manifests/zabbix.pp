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

docker::image { 'zabbix/zabbix-appliance':
  image_tag => 'latest'
}

docker::run { 'zabbix-appliance':
  image => 'zabbix/zabbix-appliance:latest',
  ports => ['80:80', '10051:10051'],
}
