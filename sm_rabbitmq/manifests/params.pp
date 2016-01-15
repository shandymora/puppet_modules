class sm_rabbitmq::params {

  $package_ensure  = 'present'
  $service_ensure  = 'running'
  $service_enabled = true

  $erlang_pkgversion      = 'R14B-04.3.el6'
  $rabbitmq_pkgversion    = '3.5.4-1'
  $manage_repos           = false
  $config_cluster         = true
  $cluster_nodes          = []
  $cluster_node_type      = 'disc'
  $config_mirrored_queues = true
  $service_manage         = true
  $amqp_port              = '5672'
  $amqp_mgmt_port         = '15672'
  $admin_enable           = true
  $delete_guest_user      = true
  $erlang_cookie          = 'PBUXYJHNJHPYJAMHDBST'
  $environment_variables  = {}

  $users                  = {}
  $vhosts                 = {}
  $permissions            = {}
  $exchanges              = {}
  $policies               = {}
  $queues                 = {}
  $bindings               = {}

}
