class sm_rabbitmq::config::create_bindings(
  
) {  
  create_resources(sm_rabbitmq::config::create_binding, $sm_rabbitmq::bindings)
}
