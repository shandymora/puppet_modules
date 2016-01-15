class sm_rabbitmq::package {

  package { 'erlang' :
    ensure => $sm_rabbitmq::erlang_pkgversion,
  }
  package { 'rubygem-carrot-top': ensure => $sm_rabbitmq::package_ensure }

  # Required for serving software/plugins locally
  package { "httpd": ensure => $sm_rabbitmq::package_ensure }
}
