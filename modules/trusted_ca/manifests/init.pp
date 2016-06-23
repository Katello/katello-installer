# == Class: trusted_ca
#
# This class installs additional trusted root CAs
#
#
# === Parameters
#
# None
#
#
# === Examples
#
# * Installation:
#
#     include trusted_ca
#     trusted_ca::ca { 'example.org.local':
#       source  => puppet:///data/ssl/example.com.pem
#     }
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class trusted_ca (
  $certificates_version = $::trusted_ca::params::certificates_version,
  $path                 = $::trusted_ca::params::path,
  $install_path         = $::trusted_ca::params::install_path,
  $update_command       = $::trusted_ca::params::update_command,
  $certfile_suffix      = $::trusted_ca::params::certfile_suffix,
  $certs_package        = $::trusted_ca::params::certs_package,
) inherits trusted_ca::params {

  if is_array($path) {
    $_path = join($path, ':')
  }
  else {
    $_path = $path
  }

  package { $certs_package:
    ensure  => $certificates_version,
  }

  exec { 'update_system_certs':
    command     => $update_command,
    path        => $_path,
    logoutput   => on_failure,
    refreshonly => true,
  }

}
