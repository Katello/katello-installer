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
# $num_pulp_workers::   Number of pulp workers to use
#
# $package_names::      Packages that this module ensures are present instead of the default
#
# $enable_ostree::      Boolean to enable ostree plugin. This requires existence of an ostree install.
#                       type:boolean
#
# $max_keep_alive::     Maximum number of requests to use for the apache MaxKeepAliveRequests parameter
#                       on the virtualHost for port 443.
#                       type: integer
#
class katello (

  $user = $katello::params::user,
  $group = $katello::params::group,
  $user_groups = $katello::params::user_groups,

  $oauth_key = $katello::params::oauth_key,
  $oauth_secret = $katello::params::oauth_secret,

  $post_sync_token = $katello::params::post_sync_token,
  $num_pulp_workers = $katello::params::num_pulp_workers,
  $log_dir = $katello::params::log_dir,
  $config_dir = $katello::params::config_dir,

  $use_passenger = $katello::params::use_passenger,

  $proxy_url      = $katello::params::proxy_url,
  $proxy_port     = $katello::params::proxy_port,
  $proxy_username = $katello::params::proxy_username,
  $proxy_password = $katello::params::proxy_password,
  $cdn_ssl_version = $katello::params::cdn_ssl_version,

  $package_names = $katello::params::package_names,
  $enable_ostree = $katello::params::enable_ostree,
  $max_keep_alive = $katello::params::max_keep_alive,
  ) inherits katello::params {
  validate_bool($enable_ostree)
  validate_integer($max_keep_alive)

  Class['certs'] ~>
  class { '::certs::apache': } ~>
  class { '::katello::install': } ~>
  class { '::katello::config': } ~>
  class { '::certs::qpid': } ~>
  class { '::certs::candlepin': } ~>
  class { '::candlepin':
    user_groups                  => $katello::user_groups,
    oauth_key                    => $katello::oauth_key,
    oauth_secret                 => $katello::oauth_secret,
    deployment_url               => $katello::deployment_url,
    ca_key                       => $certs::ca_key,
    ca_cert                      => $certs::ca_cert_stripped,
    keystore_password            => $::certs::candlepin::keystore_password,
    truststore_password          => $::certs::candlepin::keystore_password,
    enable_basic_auth            => false,
    consumer_system_name_pattern => '.+',
    adapter_module               => 'org.candlepin.katello.KatelloModule',
    amq_enable                   => true,
    amqp_keystore_password       => $::certs::candlepin::keystore_password,
    amqp_truststore_password     => $::certs::candlepin::keystore_password,
    amqp_keystore                => $::certs::candlepin::amqp_keystore,
    amqp_truststore              => $::certs::candlepin::amqp_truststore,
  } ~>
  class { '::qpid':
    ssl                    => true,
    ssl_cert_db            => $::certs::nss_db_dir,
    ssl_cert_password_file => $::certs::qpid::nss_db_password_file,
    ssl_cert_name          => 'broker',
  } ~>
  class { '::certs::pulp_parent': } ~>
  class { '::pulp':
    oauth_enabled          => true,
    oauth_key              => $katello::oauth_key,
    oauth_secret           => $katello::oauth_secret,
    messaging_url          => "ssl://${::fqdn}:5671",
    messaging_ca_cert      => $certs::pulp_parent::messaging_ca_cert,
    messaging_client_cert  => $certs::pulp_parent::messaging_client_cert,
    messaging_transport    => 'qpid',
    messaging_auth_enabled => false,
    broker_url             => "qpid://${::fqdn}:5671",
    broker_use_ssl         => true,
    consumers_crl          => $candlepin::crl_file,
    proxy_url              => $proxy_url,
    proxy_port             => $proxy_port,
    proxy_username         => $proxy_username,
    proxy_password         => $proxy_password,
    manage_broker          => false,
    manage_httpd           => false,
    manage_plugins_httpd   => true,
    manage_squid           => true,
    enable_rpm             => true,
    enable_puppet          => true,
    enable_docker          => true,
    enable_ostree          => $enable_ostree,
    num_workers            => $num_pulp_workers,
    enable_parent_node     => true,
    repo_auth              => true,
  } ~>
  class { '::qpid::client':
    ssl                    => true,
    ssl_cert_name          => 'broker',
    ssl_cert_db            => $certs::nss_db_dir,
    ssl_cert_password_file => $certs::qpid::nss_db_password_file,
  } ~>
  class { '::katello::qpid':
    client_cert  => $certs::qpid::client_cert,
    client_key   => $certs::qpid::client_key,
    katello_user => $katello::user,
  } ~>
  Exec['foreman-rake-db:seed']

  class { '::certs::foreman': }

  Service['httpd'] -> Exec['foreman-rake-db:seed']

  User<|title == apache|>{groups +> $user_groups}
}
