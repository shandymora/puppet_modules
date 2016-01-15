class sm_graphite (
  $package_ensure	= 'present',
  $service_ensure	= 'running',
  $service_enabled	= true, 

  $carbon_package_name                   = 'python-carbon',
  $carbon_version                        = '0.9.14-1',
  $whisper_version                       = '0.9.14-1',
  $graphite_web_version                  = '0.9.14-1',
  $carbon_cache_enabled                  = true,
  $carbon_cache_max_cache_size           = '1000000',
  $carbon_cache_max_updates_ps           = '5000',
  $carbon_cache_max_creates_per_minute   = '500',
  $carbon_cache_line_receiver_interface  = '0.0.0.0',
  $carbon_cache_line_receiver_port       = '2003',
  $carbon_cache_pickle_receiver_interface  = '0.0.0.0',
  $carbon_cache_pickle_receiver_port       = '2004',
  $carbon_cache_log_listener_connections = 'True',
  $carbon_cache_log_updates              = 'False',
  $carbon_cache_log_cache_hits           = 'False',
  $carbon_cache_log_cache_queue_sorts    = 'True',
  $carbon_cache_enable_amqp              = false,
  $carbon_cache_amqp_host                = undef,
  $carbon_cache_amqp_port                = undef,
  $carbon_cache_amqp_vhost               = undef,
  $carbon_cache_amqp_user                = undef,
  $carbon_cache_amqp_password            = undef,
  $carbon_cache_amqp_exchange            = undef,
  $carbon_cache_amqp_metric_name_in_body = false,
  $carbon_metric_prefix                  = '',
  $use_white_list                        = false,
  $blacklist_rules                       = [],
  
  $graphite_web_log_rendering_performance = 'False',
  $graphite_web_log_cache_performance     = 'False',
  $graphite_web_log_metric_access         = 'False',

  $carbon_relay_enabled                    = false,
  $carbon_relay_line_receiver_interface    = '0.0.0.0',
  $carbon_relay_line_receiver_port         = '2013',
  $carbon_relay_pickle_receiver_interface    = '0.0.0.0',
  $carbon_relay_pickle_receiver_port         = '2014',
  $carbon_relay_relay_method               = 'rules',
  $carbon_relay_replication_factor         = '1',
  $carbon_relay_destinations               = [ '127.0.0.1:2004', ],
  $carbon_relay_default_destinations       = [ '127.0.0.1:2004', ],
  $carbon_relay_max_datapoints_per_message = '500',
  $carbon_relay_max_queue_size             = '10000',
  $carbon_relay_use_flow_control           = 'True',
  $relay_rules                             = [],

  $carbon_aggregator_enabled                    = false,
  $carbon_aggregator_line_receiver_interface    = '0.0.0.0',
  $carbon_aggregator_line_receiver_port         = '2023',
  $carbon_aggregator_pickle_receiver_interface  = '0.0.0.0',
  $carbon_aggregator_pickle_receiver_port       = '2024',
  $carbon_aggregator_forward_all                = 'True',
  $carbon_aggregator_destinations               = [ '127.0.0.1:2004', ],
  $carbon_aggregator_replication_factor         = '1',
  $carbon_aggregator_max_queue_size             = '10000',
  $carbon_aggergator_use_flow_control           = 'True',
  $carbon_aggregator_max_datapoints_per_message = '500',
  $carbon_aggregator_max_aggregation_intervals  = '5',
  $carbon_aggregator_enable_amqp                = false,
  $carbon_aggregator_amqp_host                  = undef,
  $carbon_aggregator_amqp_port                  = undef,
  $carbon_aggregator_amqp_vhost                 = undef,
  $carbon_aggregator_amqp_user                  = undef,
  $carbon_aggregator_amqp_password              = undef,
  $carbon_aggregator_amqp_exchange              = undef,
  $carbon_aggregator_amqp_metric_name_in_body   = false,

  $storage_schemas_default = [
    {
      name       => 'carbon',
      pattern    => '^carbon\.',
      retentions => [ '60s:90d', ]
    },
    {
      name       => 'default-schema',
      pattern    => '.*',
      retentions => [ '60s:90d', ]
    },
  ],
  $storage_schemas_extra   = [],
  
  $aggregation_rules = [],

) {

  anchor { 'sm_graphite::begin': } ->
    class { 'sm_graphite::package': } ->
    class { 'sm_graphite::config': } ->
    class { 'sm_graphite::service': }
  anchor { 'sm_graphite::end': }
}
