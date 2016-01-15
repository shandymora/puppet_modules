class sm_graphite::service (

) {


  if ($sm_graphite::carbon_cache_enabled == true) {
    $ensure_carbon_cache = 'running'
  } else {
    $ensure_carbon_cache = 'stopped'
  }
  if ($sm_graphite::carbon_relay_enabled == true) {
    $ensure_carbon_relay = 'running'
  } else {
    $ensure_carbon_relay = 'stopped'
  }
  if ($sm_graphite::carbon_aggregator_enabled == true) {
    $ensure_carbon_aggregator = 'running'
  } else {
    $ensure_carbon_aggregator = 'stopped'
  }

  
  service { 'httpd':
    ensure     => $sm_graphite::service_ensure,
    enable     => $sm_graphite::service_enabled,
    hasstatus  => true,
    hasrestart => true,
  }
 
  service { 'carbon-cache' :
    ensure     => $ensure_carbon_cache,
    enable     => $sm_graphite::carbon_cache_enabled,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => File['/opt/graphite/conf/carbon.conf'],
  }

  service { 'carbon-relay' :
    ensure     => $ensure_carbon_relay,
    enable     => $sm_graphite::carbon_relay_enabled,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => [
      File['/opt/graphite/conf/carbon.conf'],
      File['/opt/graphite/conf/relay-rules.conf']
    ],
  }

  service { 'carbon-aggregator' :
    ensure     => $ensure_carbon_aggregator,
    enable     => $sm_graphite::carbon_aggregator_enabled,
    hasstatus  => true,
    hasrestart => true,
    subscribe  => File['/opt/graphite/conf/carbon.conf'],
  }

}

