class sm_rabbitmq (
  $package_ensure  = $sm_rabbitmq::params::package_ensure,
  $service_ensure  = $sm_rabbitmq::params::service_ensure,
  $service_enabled = $sm_rabbitmq::params::service_enabled,
  
  $erlang_pkgversion      = $sm_rabbitmq::params::erlang_pkgversion,
  $rabbitmq_pkgversion    = $sm_rabbitmq::params::rabbitmq_pkgversion,
  $manage_repos           = $sm_rabbitmq::params::manage_repos,
  $config_cluster         = $sm_rabbitmq::params::config_cluster,
  $cluster_nodes          = $sm_rabbitmq::params::cluster_nodes,
  $cluster_node_type      = $sm_rabbitmq::params::cluster_node_type,
  $config_mirrored_queues = $sm_rabbitmq::params::config_mirrored_queues,
  $service_manage         = $sm_rabbitmq::params::service_manage,
  $amqp_port              = $sm_rabbitmq::params::amqp_port,
  $amqp_mgmt_port         = $sm_rabbitmq::params::amqp_mgmt_port,
  $admin_enable           = $sm_rabbitmq::params::admin_enable,
  $delete_guest_user      = $sm_rabbitmq::params::delete_guest_user,
  $erlang_cookie          = $sm_rabbitmq::params::erlang_cookie,
  $environment_variables  = $sm_rabbitmq::params::environment_variables,
  
  $users                  = $sm_rabbitmq::params::users,
  $vhosts                 = $sm_rabbitmq::params::vhosts,
  $permissions            = $sm_rabbitmq::params::permissions,
  $exchanges              = $sm_rabbitmq::params::exchanges,
  $policies               = $sm_rabbitmq::params::policies,
  $queues                 = $sm_rabbitmq::params::queues,
  $bindings               = $sm_rabbitmq::params::bindings,
  
) inherits sm_rabbitmq::params {

  validate_re($package_ensure, ['^absent$', '^present$', '^latest$', '^installed$'])
  validate_re($service_ensure, ['^stopped$', '^running$'])
  validate_bool($service_enabled)

  validate_string($erlang_pkgversion)
  validate_string($rabbitmq_pkgversion)
  validate_bool($manage_repos)
  validate_bool($config_cluster)
  validate_array($cluster_nodes)
  validate_string($cluster_node_type)
  validate_bool($config_mirrored_queues)
  validate_bool($service_manage)
  validate_re($amqp_port, [ '^[0-9]+'])
  validate_re($amqp_mgmt_port, [ '^[0-9]+'])
  validate_string($amqp_vhost)
  validate_string($amqp_uname)
  validate_string($amqp_pword)
  validate_bool($admin_enable)
  validate_bool($delete_guest_user)
#  validate_string($soft_limit)
#  validate_string($hard_limit)
  validate_hash($users)
  validate_hash($vhosts)
  validate_hash($permissions)
  validate_hash($exchanges)
  
  anchor { 'sm_rabbitmq::begin':  } ->
  class  { 'sm_rabbitmq::package': } ->
  class  { 'sm_rabbitmq::config':  } ->
  class  { 'sm_rabbitmq::preinstall':  } ->
  class  { 'sm_rabbitmq::install':  } ->
  class  { 'sm_rabbitmq::postinstall': } ->
  anchor { 'sm_rabbitmq::end':   }
  
}
