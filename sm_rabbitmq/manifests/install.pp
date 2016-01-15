class sm_rabbitmq::install {

  $default_env_variables = {
    'RABBITMQ_NODENAME'    => "rabbit@${::hostname}",
    'RABBITMQ_MNESIA_BASE' => "/opt/rabbitmq/mnesia"
  }
  # Handle env variables.
  $environment_variables = merge($default_env_variables, $sm_rabbitmq::environment_variables)

   # Create Cluster
   class { '::rabbitmq':
      admin_enable             => $sm_rabbitmq::admin_enable,
      management_port          => $sm_rabbitmq::amqp_mgmt_port,
      package_ensure           => $sm_rabbitmq::rabbitmq_pkgversion,
      version                  => $sm_rabbitmq::rabbitmq_pkgversion,
      package_provider         => 'yum',
      service_ensure           => $sm_rabbitmq::service_ensure,
      service_manage           => $sm_rabbitmq::service_manage,
      cluster_node_type        => $sm_rabbitmq::cluster_node_type,
      cluster_nodes            => $sm_rabbitmq::cluster_nodes,
      config_cluster           => $sm_rabbitmq::config_cluster,
      erlang_cookie            => $sm_rabbitmq::erlang_cookie,
      wipe_db_on_cookie_change => true,
      delete_guest_user        => $sm_rabbitmq::delete_guest_user,
      port                     => $sm_rabbitmq::amqp_port,
      environment_variables    => $environment_variables,
      config_variables         => {
        'heartbeat'     => 280,
        'hipe_compile'  => false,
        'frame_max'     => 131072,
        'log_levels'    => "[{connection, info}]"
      },
      config_kernel_variables  => {
        'inet_dist_listen_min' => 9100,
        'inet_dist_listen_max' => 9105,
      },
    } 

}
