$project  = 'zeg-webops'
$cred_path = '/home/pg/.googlecred/efae2426d709.json'
$vm = 'zeg-centos7-instance'

gauth_credential { 'cred':
  provider => serviceaccount,
  path     => $cred_path,
  scopes   => ['https://www.googleapis.com/auth/compute'],
}

gcompute_network { 'default':
  project    => $project,
  credential => 'cred',
}

gcompute_region { 'us-east1':
  project    => $project,
  credential => 'cred',
}

gcompute_zone { 'us-east1-b':
  project    => $project,
  credential => 'cred',
}

gcompute_machine_type { 'n1-standard-1':
  zone       => 'us-east1-b',
  project    => $project,
  credential => 'cred',
}

gcompute_address { $vm:
  ensure     => present,
  region     => 'us-east1',
  project    => $project,
  credential => 'cred',
}

gcompute_disk { $vm:
  ensure       => present,
  size_gb      => 50,
  source_image => gcompute_image_family('centos-7', 'centos-cloud'),
  zone         => 'us-east1-b',
  project      => $project,
  credential   => 'cred',
}

gcompute_instance { $vm:
  ensure             => present,
  machine_type       => 'n1-standard-1',
  disks              => [
    {
      boot        => true,
      source      => $vm,
      auto_delete => true,
    }
  ],
  network_interfaces => [
    {
      network        => 'default',
      access_configs => [
        {
          name   => 'External NAT',
          nat_ip => $vm,
          type   => 'ONE_TO_ONE_NAT',
        }
      ],
    }
  ],
  zone               => 'us-east1-b',
  project            => $project,
  credential         => 'cred',
}

gcompute_firewall { 'allow-zabbix-ports':
  ensure        => present,
  allowed       => [
    {
      ip_protocol => 'tcp',
      ports       => [
        '80',
        '10051',
      ],
    },
  ],
  source_ranges => [
    '0.0.0.0/0'
  ],
  project       => $project,
  credential    => 'cred',
}
