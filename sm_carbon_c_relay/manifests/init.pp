class sm_carbon_c_relay (
  $package_ensure   = $sm_carbon_c_relay::params::package_ensure,
  $service_ensure   = $sm_carbon_c_relay::params::service_ensure,
  $service_enabled  = $sm_carbon_c_relay::params::service_enabled,
  $in_ports         = $sm_carbon_c_relay::params::in_ports,
  $out_ports        = $sm_carbon_c_relay::params::out_ports,
  $workers          = $sm_carbon_c_relay::params::workers,
  $logfile 	    = $sm_carbon_c_relay::params::logfile,
  $send_size	    = $sm_carbon_c_relay::params::send_size,
  $queue_size	    = $sm_carbon_c_relay::params::queue_size,
  $stats_interval   = $sm_carbon_c_relay::params::stats_interval,
  $cluster_routes   = $sm_carbon_c_relay::params::cluster_routes,
  $cluster_matches  = $sm_carbon_c_relay::params::cluster_matches,
) inherits sm_carbon_c_relay::params {

  ## Validation on inputs with stdlib functions:

  # validate_absolute_path()
  # validate_array()
  # validate_bool()
  # validate_hash()
  # validate_re()
  # validate_slength()
  # validate_string()

  validate_re($package_ensure, ['^absent$', '^present$', '^latest$', '^installed$'])
  validate_re($service_ensure, ['^stopped$', '^running$'])
  validate_bool($service_enabled)

  validate_array($in_ports)
  validate_array($out_ports)
  validate_array($cluster_routes)
  validate_array($cluster_matches)
  validate_string($workers)
  
  anchor { 'sm_carbon_c_relay::begin':  } ->
  class  { 'sm_carbon_c_relay::package': } ->
  class  { 'sm_carbon_c_relay::config':  } ->
  class  { 'sm_carbon_c_relay::service': } ->
  anchor { 'sm_carbon_c_relay::end':   }
}
