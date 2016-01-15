class sm_rabbitmq::config::create_exchanges(
  
) {  
  create_resources(sm_rabbitmq::config::create_exchange, $sm_rabbitmq::exchanges)
}