define sm_rabbitmq::config::create_exchange(
  $vhost,
  $exchange,
  $username,
  $type         = 'direct',
  $ensure       = present,
  $internal     = false,
  $auto_delete  = false,
  $durable      = true,
  $arguments    = {},
) {
  $password = $sm_rabbitmq::users["${username}"][password]
  


  validate_string($vhost)
  validate_string($exchange)
  validate_string($username)
  validate_string($password)
  validate_string($type)
  validate_re($ensure, ['^absent$', '^present$'] )
  validate_bool($internal)
  validate_bool($auto_delete)
  validate_bool($durable)
  validate_hash($arguments)
  
  rabbitmq_exchange { "${exchange}@${vhost}" :
    user        => $username,
    password    => $password,
    type        => $type,
    ensure      => $ensure,
    internal    => $internal,
    auto_delete => $auto_delete,
    durable     => $durable,
    arguments   => $arguments,
    require     => [ Class['::rabbitmq'], Rabbitmq_user[$username], Rabbitmq_vhost[$vhost] ],
  }
}

