class sm_rabbitmq::config::create_queues(
  
) {  
  create_resources(sm_rabbitmq::config::create_queue, $sm_rabbitmq::queues)
}
