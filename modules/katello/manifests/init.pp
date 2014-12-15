# == Class: katello
#
# Install and configure katello
#
# === Parameters:
#
# $user::               The Katello system user name
#
# $group::              The Katello system user group
#
# $user_groups::        Extra user groups the Katello user is a part of
#
# $oauth_key::          The oauth key for talking to the candlepin API
#
# $oauth_secret::       The oauth secret for talking to the candlepin API
#
# $post_sync_token::    The shared secret for pulp notifying katello about
#                       completed syncs
#
# $log_dir::            Location for Katello log files to be placed
#
# $config_dir::         Location for Katello config files
#
# $use_passenger::      Whether Katello is being deployed with Passenger
#
# $proxy_url::          URL of the proxy server
#
# $proxy_port::         Port the proxy is running on
#
# $proxy_username::     Proxy username for authentication
#
# $proxy_password::     Proxy password for authentication
#
# $cdn_ssl_version::    SSL version used to communicate with the CDN. Optional. Use SSLv23 or TLSv1
#
# $gutterball::         Configures gutterball
#                       type:boolean
class katello (

  $user = $katello::params::user,
  $group = $katello::params::group,
  $user_groups = $katello::params::user_groups,

  $oauth_key = $katello::params::oauth_key,
  $oauth_secret = $katello::params::oauth_secret,

  $post_sync_token = $katello::params::post_sync_token,

  $log_dir = $katello::params::log_dir,
  $config_dir = $katello::params::config_dir,

  $use_passenger = $katello::params::use_passenger,

  $proxy_url      = $katello::params::proxy_url,
  $proxy_port     = $katello::params::proxy_port,
  $proxy_username = $katello::params::proxy_username,
  $proxy_password = $katello::params::proxy_password,
  $cdn_ssl_version = $katello::params::cdn_ssl_version,

  $gutterball = $katello::params::gutterball

  ) inherits katello::params {

  Class['certs'] ~>
  class { 'certs::apache': } ~>
  class { 'certs::katello':
    deployment_url => $katello::rhsm_url,
  } ~>
  class { 'katello::install': } ~>
  class { 'katello::config': } ~>
  class { 'certs::qpid': } ~>
  class { 'certs::candlepin': } ~>
  class { 'candlepin':
    user_groups       => $katello::user_groups,
    oauth_key         => $katello::oauth_key,
    oauth_secret      => $katello::oauth_secret,
    deployment_url    => $katello::deployment_url,
    ca_key            => $certs::ca_key,
    ca_cert           => $certs::ca_cert_stripped,
    keystore_password => $::certs::candlepin::keystore_password,
  } ~>
  class { 'certs::pulp_parent': } ~>
  class { 'pulp':
    oauth_key                   => $katello::oauth_key,
    oauth_secret                => $katello::oauth_secret,
    messaging_url               => "ssl://${::fqdn}:5671",
    qpid_ssl_cert_db            => $certs::nss_db_dir,
    qpid_ssl_cert_password_file => $certs::qpid::nss_db_password_file,
    messaging_ca_cert           => $certs::pulp_parent::messaging_ca_cert,
    messaging_client_cert       => $certs::pulp_parent::messaging_client_cert,
    consumers_ca_cert           => $certs::ca_cert,
    consumers_ca_key            => $certs::ca_key,
    consumers_crl               => $candlepin::crl_file,
    proxy_url                   => $proxy_url,
    proxy_port                  => $proxy_port,
    proxy_username              => $proxy_username,
    proxy_password              => $proxy_password,
  } ~>
  class { 'crane':
    cert    => $certs::apache::apache_cert,
    key     => $certs::apache::apache_key,
    ca_cert => $certs::ca_cert,
  } ~>
  class { 'qpid::client': } ~>
  class { 'katello::qpid':
    client_cert  => $certs::qpid::client_cert,
    client_key   => $certs::qpid::client_key,
    katello_user => $katello::user,
  } ~>
  class{ 'elasticsearch': } ~>
  Exec['foreman-rake-db:seed']

  class { 'certs::foreman': }

  class { 'katello::service': }

  Service['httpd'] -> Exec['foreman-rake-db:seed']

  if $katello::gutterball {
    Class[ 'certs' ] ->
    class { 'certs::gutterball': } ->
    class { 'gutterball':
      keystore_password => $certs::gutterball::gutterball_keystore_password,
    }
  }

  User<|title == apache|>{groups +> $user_groups}
}
