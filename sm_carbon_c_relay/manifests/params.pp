class sm_carbon_c_relay::params {

  $package_ensure  = 'present'
  $service_ensure  = 'running'
  $service_enabled = true

  $in_ports         = [ '2013' ]
  $out_ports        = [ '2003' ]
  $workers          = '2'
  $logfile	    = '/var/log/carbon-c-relay/carbon-c-relay.log'
  $send_size	    = '2500'
  $queue_size	    = '25000'
  $stats_interval   = '60'
  $cluster_routes   = [
    {
      name  =>  "send-through",
      type  =>  "forward",
      hosts =>  [ "127.0.0.1" ]
    }
  ]
  $cluster_matches  = [
    {
      pattern   => "*",
      send_to   => "send-through",
      stop      => true
    }
  
  ]
}
