class sm_rabbitmq::config::create_users(
  
) {
  create_resources(sm_rabbitmq::config::create_user, $sm_rabbitmq::users)
}