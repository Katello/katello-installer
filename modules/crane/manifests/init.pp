# == Class: crane
#
# Install and configure Crane
#
# === Parameters:
#
# $key::     Path to the SSL key for https
#
# $cert::    Path to the SSL certificate for https
#
# $ca_cert:: Path to the SSL CA cert for https
#
class crane (
  $key = $crane::params::key,
  $cert = $crane::params::cert,
  $ca_cert = $crane::params::ca_cert,

  ) inherits crane::params {

  class { '::crane::install': } ~>
  class { '::crane::apache': } ~>
  class { '::crane::config': } ~>
  Service['httpd']
  ->
  Class['crane']
}
