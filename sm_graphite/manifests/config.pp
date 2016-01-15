class sm_graphite::config (

) {

  # Ensure Graphite directory/file structure exists
  file { '/opt/graphite':
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755',
  }

  file { '/opt/graphite/storage':
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0755',
    require => File['/opt/graphite'],
  }

  # Setup Apache configuration
  file { '/etc/httpd/wsgi':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/httpd/conf.d/graphite.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/httpd/graphite-vhost.conf"
  }

  file { '/opt/sm_graphite/conf/graphite.wsgi':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/conf/graphite.wsgi"
  }

  # Set log directories
  file { '/opt/graphite/storage/log/webapp':
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755',
  }

  # Django Web application configuration files
  file { '/opt/graphite/webapp/graphite/local_settings.py':
    ensure  => file,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    content => template("${module_name}/webapp/local_settings.py.erb"),
    notify  => Service['httpd'],
  }

  file { '/opt/graphite/webapp/graphite/app_settings.py':
    ensure => file,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/webapp/app_settings.py",
  }

  # Custom logger.py script to fix bug when disabling excessive logging.  This is a fork from the orginal source!!!!
#  file { '/opt/sm_graphite/webapp/sm_graphite/logger.py':
#    ensure => file,
#    owner  => 'apache',
#    group  => 'apache',
#    mode   => '0644',
#    source => "puppet:///modules/${module_name}/webapp/logger.py",
#  }

  # Set permissions on sqlite DB for Django app.
  file { '/opt/graphite/storage/graphite.db':
    ensure  => file,
    replace => false,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/webapp/graphite.db",
  }

  # Fix for missing Django CSS files, need to be copied from templates section
  file { '/usr/lib/python2.6/site-packages/django/contrib/admin/media':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  exec { 'copy_templates':
    cwd     => '/usr/lib/python2.6/site-packages/django/contrib/admin',
    command => 'cp -R templates/* media/',
    creates => '/usr/lib/python2.6/site-packages/django/contrib/admin/media/admin/404.html',
    require => File['/usr/lib/python2.6/site-packages/django/contrib/admin/media'],
    path    => ['/bin', '/usr/bin'],
  }

  exec { 'copy_static-admin':
    cwd     => '/usr/lib/python2.6/site-packages/django/contrib/admin',
    command => 'cp -R static/admin/* media/admin/',
    creates => '/usr/lib/python2.6/site-packages/django/contrib/admin/media/admin/css/base.css',
    require => [
      File['/usr/lib/python2.6/site-packages/django/contrib/admin/media'],
      Exec['copy_templates'] ],
    path    => ['/bin', '/usr/bin'],
  }

  # Graphite Carbon configuration file.
  file { '/opt/graphite/conf/carbon.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/conf/carbon.conf.erb"),
  }

  # Relay rules for carbon-relay service
  file { '/opt/graphite/conf/relay-rules.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/conf/relay-rules.conf.erb"),
  }
  # Graphite storage schema configuration file, this is automatically re-read every 60s by the app.  No subscribe needed
  file { '/opt/graphite/conf/storage-schemas.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/conf/storage-schemas.conf.erb"),
  }

  # Graphite carbon-aggregator Rules
  file { '/opt/graphite/conf/aggregation-rules.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/conf/aggregation-rules.conf.erb"),
  }

  # Needs templating to erb.
  file { '/opt/graphite/conf/storage-aggregation.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/conf/storage-aggregation.conf"
  }

  # Graph Templates, needs templating to erb.
  file { '/opt/graphite/conf/graphTemplates.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/conf/graphTemplates.conf"
  }

  # Blacklist of metrics
  file { '/opt/graphite/conf/blacklist.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/conf/blacklist.conf.erb"),
  }

  # logrotate config
  file { '/etc/logrotate.d/graphite.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/logrotate/graphite.conf",
  }

  # Startup init scripts
  file {
    '/etc/init.d/carbon-cache':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => "puppet:///modules/${module_name}/init.d/carbon-cache"
    ;
    '/etc/init.d/carbon-relay':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => "puppet:///modules/${module_name}/init.d/carbon-relay"
    ;
    '/etc/init.d/carbon-aggregator':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => "puppet:///modules/${module_name}/init.d/carbon-aggregator"
  }

  #
  #  Ensure scripts directory structure is in place
  #
  file {
    '/opt/scripts' :
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    ;
    '/opt/scripts/graphite' :
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755'
  }
  #
  #  Sync scripts
  #
  file { '/opt/scripts/graphite/filepurge.rb':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => "puppet:///modules/${module_name}/scripts/filepurge.rb"
  }

  # Cron entries
  cron { "${module_name}: Run index of Graphite keys":
    ensure  => present,
    user    => 'root',
    minute  => '0',
    hour    => '*/1',
    command => '/opt/graphite/bin/build-index.sh',
    ;
    "${module_name}: Run file purge on Graphite whisper data store on 1st of the month and delete any files not accessed and modified in last 31 days":
    ensure   => present,
    user     => 'root',
    minute   => '0',
    hour     => '1',
    monthday => '1',
    command  => '/usr/bin/ruby /opt/scripts/graphite/filepurge.rb --dir /opt/graphite/storage/whisper/lmn --action delete --timeframe 31 --pathdepth 20',
  }

}

