define sm_fstab::config::update_fstab(
  $ensure      = mounted,
  $source,
  $dest,
  $type,
  $opts        = 'defaults',
  $dump        = 0,
  $passno      = 0,
  $dest_owner  = 'root',
  $dest_group  = 'root',
  $dest_mode   = '0755',
) {

  validate_re($ensure, ['^mounted$', '^present$', '^unmounted', '^absent'])
  validate_string($source)
  validate_string($dest)
  validate_string($type)
  validate_string($opts)
  
  # Ensure mount dirs exists 
  if $ensure == 'mounted' or $ensure == 'present' {
    exec { "make_dir${dest}":
      command  => "/bin/mkdir -p ${dest}",
      unless   => "/usr/bin/test -d ${dest}",
    } ->
    # Update fstab and mount
    mount { $dest: 
      ensure      => $ensure,
      atboot      => true,
      device      => $source,
      dump        => $dump,
      fstype      => $type,
      options     => $opts,
      pass        => $passno,
    } -> 
    file { $dest:
      ensure => directory,
      owner  => $dest_owner,
      group  => $dest_group,
      mode   => $dest_mode, 
    }
  }
  if $ensure == 'unmounted' or $ensure == 'absent' {
    # Update fstab and unmount
    mount { $dest:
      ensure    => $ensure,
      notify    => Exec["remove_mountpoint_${dest}"],
    }
    exec { "remove_mountpoint_${dest}":
      command     => "/bin/rm -rf ${dest}",
      refreshonly => true,
    }
  }

}

