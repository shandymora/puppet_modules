class sm_rabbitmq::config::set_permissions(
  
) {
  create_resources(sm_rabbitmq::config::set_permission, $sm_rabbitmq::permissions)
}