class sm_rabbitmq::config {

  group { 'rabbitmq': 
    ensure   => present,
    gid      => '3004',
  }
  user { 'rabbitmq':
    ensure   => present,
    uid      => 3004,
    gid      => 'rabbitmq',
    home     => '/var/lib/rabbitmq', 
    shell    => '/bin/bash',
    require  => [ Group['rabbitmq'] ],
  }
  file { '/var/lib/rabbitmq': 
    ensure    => directory,
    owner     => 'rabbitmq',
    group     => 'rabbitmq',
    mode      => '0755',
    require   => [ User['rabbitmq'], Group['rabbitmq'] ],
  }
  file { '/var/log/rabbitmq': 
    ensure    => directory,
    owner     => 'rabbitmq',
    group     => 'rabbitmq',
    mode      => '0755',
    require   => [ User['rabbitmq'], Group['rabbitmq'] ],
  }

  # Mnesia, message and index file location
  file {
    '/opt/rabbitmq' :
      ensure   => directory,
      owner    => 'rabbitmq',
      group    => 'rabbitmq',
      mode     => '0755',
      require  => [ User['rabbitmq'], Group['rabbitmq'] ],
    ;
    '/opt/rabbitmq/mnesia':
      ensure   => directory,
      owner    => 'rabbitmq',
      group    => 'rabbitmq',
      mode     => '0755',
      require  => [ User['rabbitmq'], Group['rabbitmq'] ],
  }

  # HTTPD config
  file { '/etc/httpd/conf/httpd.conf':
    ensure => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/httpd/httpd.conf",
    notify  => Service [ 'httpd' ],
  }

  # Directory and sync files for plugins
  file {
    '/var/www/html/software' :
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      recurse => true,
      source => "puppet:///modules/${module_name}/software",
  }
}
