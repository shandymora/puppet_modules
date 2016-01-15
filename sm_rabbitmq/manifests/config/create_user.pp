define sm_rabbitmq::config::create_user(
  $username,
  $password,
  $admin        = false,
) {

  validate_string($username)
  validate_string($password)
  validate_bool($admin)
  
  rabbitmq_user { $username :
    admin    => $admin,
    password => $password,
    require  => Class['::rabbitmq'],
  }
}