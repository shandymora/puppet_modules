class sm_rabbitmq::preinstall {

  service { 'httpd':
    ensure     => $sm_rabbitmq::service_ensure,
    enable     => $sm_rabbitmq::service_enabled,
    hasstatus  => true,
    hasrestart => true,
  }

}

