define sm_rabbitmq::config::create_policy(
  $vhost     = undef,
  $pattern   = undef,
  $priority  = undef,
  $applyto   = undef,
  $definition = undef,
) {

  validate_string($vhost)
  validate_string($pattern)
  validate_string($applyto)
  validate_hash($definition)
  
  $vhost_name = $vhost ? {
    undef   => "/",
    default => "${vhost}"
  }

  $vhost_arg = $vhost ? {
    undef   => '',
    default => "-p ${vhost}"
  }

  $applyto_arg = $applyto ? {
    undef   => '',
    default => "--apply-to ${applyto}"
  }

  $priority_arg = $priority ? {
    undef   => '',
    default => "--priority ${priority}"
  }

  $definition_json = inline_template('<%= @definition.to_json unless @definition.nil? %>')
  $definition_arg = $definition ? {
    undef   => '',
    default => "'${definition_json}'"
  }

  exec { "rabbitmq_policy_${name}@${vhost_name}": 
    command   => "/usr/sbin/rabbitmqctl set_policy ${name} ${vhost_arg} \"${pattern}\" '${definition_json}' ${applyto_arg} ${priority_arg}",
    unless   => "/usr/sbin/rabbitmqctl list_policies -p ${vhost_name}|grep \"${name}\"",
    require  => Class['::rabbitmq'],
  } 
}

