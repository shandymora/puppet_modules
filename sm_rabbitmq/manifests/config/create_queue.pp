define sm_rabbitmq::config::create_queue(
  $queue = undef,
  $vhost = undef,
  $username,
  $durable = false,
  $auto_delete = true,
  $arguments = {},
  $ensure = present, 
) {

  $password = $sm_rabbitmq::users["${username}"][password]

  $vhost_name = $vhost ? {
    undef   => "/",
    default => "${vhost}"
  }

  $queue_name = $queue ? {
    undef   => "${name}",
    default => "${queue}"
  }

  validate_string($queue_name)
  validate_string($vhost_name)
  validate_string($user)
  validate_string($password)
  validate_bool($durable)
  validate_bool($auto_delete)
  validate_hash($arguments)
  validate_re($ensure, ['^absent$', '^present$', '^latest$', '^installed$'])
  
  rabbitmq_queue { "${queue_name}@${vhost_name}":
    user        => $username,
    password    => $password,
    durable     => $durable,
    auto_delete => $auto_delete,
    arguments   => $arguments,
    ensure      => $ensure,
    require     => [ Class['::rabbitmq'], Rabbitmq_user[$username], Rabbitmq_vhost[$vhost_name] ],
  }
}
