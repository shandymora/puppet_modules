class sm_rabbitmq::postinstall (

) {
  # Create vhosts
  class { 'sm_rabbitmq::config::create_vhosts': }

  # Create users
  class { 'sm_rabbitmq::config::create_users': }

  # Set user permissions
  class { 'sm_rabbitmq::config::set_permissions': }

  # Create exchanges
  class { 'sm_rabbitmq::config::create_exchanges': }
 
  # Create policies
  class { 'sm_rabbitmq::config::create_policies': }

  # Create queues
  class { 'sm_rabbitmq::config::create_queues': }

  # Create bindings
  class { 'sm_rabbitmq::config::create_bindings': }
}

