define sm_rabbitmq::config::set_permission(
  $vhost,
  $username,
  $configure_permission,
  $read_permission,
  $write_permission,
) {
  

  
  validate_string($vhost)
  validate_string($username)
  validate_string($configure_permission)
  validate_string($read_permission)
  validate_string($write_permission)
  
  rabbitmq_user_permissions { "${username}@${vhost}" :
    configure_permission => $configure_permission,
    read_permission      => $read_permission,
    write_permission     => $write_permission,
    require              => [ Class['::rabbitmq'], Rabbitmq_user[$username], Rabbitmq_vhost[$vhost] ],
  }
}