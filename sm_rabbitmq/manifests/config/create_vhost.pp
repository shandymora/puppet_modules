define sm_rabbitmq::config::create_vhost(
  $vhost,
  $ensure = present
) {
  
  
  
  validate_string($vhost)
  validate_re($ensure, ['^absent$', '^present$'] )
  
  rabbitmq_vhost { $vhost :
    ensure  => $ensure,
    require => Class['::rabbitmq'],
  }
}

