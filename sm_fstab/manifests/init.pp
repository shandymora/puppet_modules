class sm_fstab (
  $package_ensure  = $sm_fstab::params::package_ensure,
  $service_ensure  = $sm_fstab::params::service_ensure,
  $service_enabled = $sm_fstab::params::service_enabled,
  $fstab_entries   = {},
) inherits sm_fstab::params {

  ## Validation on inputs with stdlib functions:

  validate_re($package_ensure, ['^absent$', '^present$', '^latest$', '^installed$'])
  validate_re($service_ensure, ['^stopped$', '^running$'])
  validate_bool($service_enabled)
  validate_hash($fstab_entries)

  anchor { 'sm_fstab::begin':  } ->
    class  { 'sm_fstab::config':  } ->
  anchor { 'lm_rabbitmq::end':   }

}
