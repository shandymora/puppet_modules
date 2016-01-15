class sm_rabbitmq::config::create_policies(
  
) {
  $pol = $sm_rabbitmq::policies
#  notice(inline_template(' <%= @pol.inspect %>'))
  create_resources(sm_rabbitmq::config::create_policy, $sm_rabbitmq::policies)
}
