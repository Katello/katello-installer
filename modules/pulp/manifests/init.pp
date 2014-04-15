# == Class: pulp
#
# Install and configure pulp
#
# === Parameters:
#
# $oauth_key::                  The oauth key; defaults to pulp
#
# $oauth_secret::               The oauth secret; defaults to secret
#
# $messaging_url::              URL for the AMQP server that Pulp will use to
#                               communicate with nodes.
#
# $messaging_ca_cert:           The CA cert to authenicate against the AMQP server.
#
# $messaging_client_cert::      The client certificate signed by the CA cert
#                               above to authenticate.
#
# $consumers_ca_cert::          The path to the CA cert that will be used to sign customer
#                               and admin identification certificates
#
# $consumers_ca_key::           The private key for the CA cert
#
# $ssl_ca_cert::                Full path to the CA certificate used to sign the Pulp
#                               server's SSL certificate; consumers will use this to verify the
#                               Pulp server's SSL certificate during the SSL handshake
#
# $consumers_crl::              Certificate revocation list for consumers which
#                               are no valid (have had their client certs
#                               revoked)
#
# $ssl_ca_cert::                The SSL cert that will be used by Pulp to
#                               verify the connection
#
# $default_login::              Initial login; defaults to admin
#
# $default_password::           Initial password; defaults to admin
#
# $repo_auth::                  Boolean to determine whether repos managed by
#                               pulp will require authentication. Defaults
#                               to true
#
# $reset_data::                 Boolean to reset the data in MongoDB. Defaults
#                               to false
#
# $reset_cache::                Boolean to flush the cache. Defaults to false
#
# $qpid_ssl_cert_db             The location of the Qpid SSL cert database
#
# $qpid_ssl_cert_password_file  Location of the password file for the Qpid SSL cert
#
# $user_groups::                Additional user groups to add the qpid user to
#
class pulp (

  $oauth_key = $pulp::params::oauth_key,
  $oauth_secret = $pulp::params::oauth_secret,

  $messaging_url = $pulp::params::messaging_url,
  $messaging_ca_cert = $pulp::params::messaging_ca_cert,
  $messaging_client_cert = $pulp::params::messaging_client_cert,

  $consumers_ca_cert = $pulp::params::consumers_ca_cert,
  $consumers_ca_key = $pulp::params::consumers_ca_key,
  $ssl_ca_cert = $pulp::params::ssl_ca_cert,

  $consumers_crl = $pulp::params::consumers_crl,

  $ssl_ca_cert = $pulp::params::ssl_ca_cert,

  $default_password = $pulp::params::default_password,

  $repo_auth = true,

  $reset_data = false,
  $reset_cache = false,

  $qpid_ssl_cert_db = $pulp::params::qpid_ssl_cert_db,
  $qpid_ssl_cert_password_file = $pulp::params::qpid_ssl_cert_password_file

  ) inherits pulp::params {

  include ::apache

  class { 'apache::mod::wsgi':} ~>
  class { 'mongodb':
    logpath => '/var/lib/mongodb/mongodb.log',
    dbpath  => '/var/lib/mongodb',
  } ~>
  class { 'qpid':
    ssl                     => true,
    ssl_cert_db             => $qpid_ssl_cert_db,
    ssl_cert_password_file  => $qpid_ssl_cert_password_file,
    ssl_cert_name           => 'broker',
    user_groups             => $pulp::user_groups
  } ~>
  # Make sure we install the mongodb client, used by service-wait to check
  # that the server is up.
  class {'::mongodb::client':} ~>
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
