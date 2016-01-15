class sm_carbon_c_relay::config {

  file { '/etc/sysconfig/carbon-c-relay': 
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/sysconfig/carbon-c-relay.erb"),
    notify  => Service [ "carbon-c-relay" ],

  }

  file { '/etc/carbon-c-relay.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/conf/relay.conf.erb"),
    notify  => Service [ "carbon-c-relay" ],
  }

}
