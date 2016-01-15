class sm_rabbitmq::config::create_vhosts(
  
) {
  create_resources(sm_rabbitmq::config::create_vhost, $sm_rabbitmq::vhosts)
}

