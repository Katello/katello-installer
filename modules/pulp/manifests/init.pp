# == Class: pulp
#
# Install and configure pulp
#
# === Parameters:
#
# $oauth_key::                The oauth key; defaults to pulp
#
# $oauth_secret::             The oauth secret; defaults to secret
#
# $messaging_url::            URL for the AMQP server that Pulp will use to
#                             communicate with nodes.
#
# $messaging_ca_cert:         The CA cert to authenicate against the AMQP server.
#
# $messaging_client_cert::    The client certificate signed by the CA cert
#                             above to authenticate.
#
# $consumers_ca_cert::        The CA cert that the consumer will use to
#                             authenticate with the AMQP server.
#
# $consumers_ca_key::         The CA key that the consumer will use to authenticate
#                             with the AMQP server.
#
# $consumers_crl::            Certificate revocation list for consumers which
#                             are no valid (have had their client certs
#                             revoked)
#
# $ssl_ca_cert::              The SSL cert that will be used by Pulp to
#                             verify the connection
#
# $default_login::            Initial login; defaults to admin
#
# $default_password::         Initial password; defaults to admin
#
# $repo_auth::                Boolean to determine whether repos managed by
#                             pulp will require authentication. Defaults
#                             to true
#
# $reset_data::               Boolean to reset the data in MongoDB. Defaults
#                             to false
#
# $reset_cache::              Boolean to flush the cache. Defaults to false
#
class pulp (
  $oauth_key = $pulp::params::oauth_key,
  $oauth_secret = $pulp::params::oauth_secret,

  $messaging_url = $pulp::params::messaging_url,
  $messaging_ca_cert = $pulp::params::messaging_ca_cert,
  $messaging_client_cert = $pulp::params::messaging_client_cert,

  $consumers_ca_cert = $consumers_ca_cert,
  $consumers_ca_key = $consumers_ca_key,
  $consumers_crl = undef,

  $ssl_ca_cert = '/etc/pki/tls/certs/pulp_ssl_cert.crt',

  $default_login = $pulp::params::default_login,
  $default_password = $pulp::params::default_password,

  $repo_auth = true,

  $reset_data = false,
  $reset_cache = false
  ) inherits pulp::params {

  include apache

  class { 'mongodb':
    logpath => '/var/lib/mongodb/mongodb.log',
    dbpath  => '/var/lib/mongodb',
  } ~>
  class { 'qpid':
    ssl => true,
  } ~>
  class { 'pulp::install':
    require => [Class['mongodb'], Class['qpid']]
  } ~>
  class { 'pulp::config':
    require => [Class['mongodb'], Class['qpid']]
  } ~>
  Service['httpd']
  ->
  Class[pulp]
}
