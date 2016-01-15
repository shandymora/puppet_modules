define sm_rabbitmq::config::create_binding(
  $source,
  $destination,
  $vhost = undef,
  $username,
  $destination_type,
  $routing_key = '#',
  $arguments = {},
  $ensure = present, 
) {

  $password = $sm_rabbitmq::users["${username}"][password]

  $vhost_name = $vhost ? {
    undef   => "/",
    default => "${vhost}"
  }

  validate_string($source)
  validate_string($destination)
  validate_string($vhost_name)
  validate_string($username)
  validate_string($password)
  validate_string($routing_key)
  validate_hash($arguments)
  validate_re($ensure, ['^absent$', '^present$', '^latest$', '^installed$'])
  
  rabbitmq_binding { "${source}@${destination}@${vhost_name}":
    user             => $username,
    password         => $password,
    destination_type => $destination_type,
    routing_key      => $routing_key,
    arguments        => $arguments,
    ensure           => $ensure,
    require     => [ Class['::rabbitmq'], Rabbitmq_user[$username], Rabbitmq_vhost[$vhost_name] ],
  }
}
