class sm_carbon_c_relay::service {

  service { 'carbon-c-relay':
    ensure     => $sm_carbon_c_relay::service_ensure,
    enable     => $sm_carbon_c_relay::service_enabled,
    hasstatus  => true,
    hasrestart => true,
  }

}
