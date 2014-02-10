# == Class: katello
#
# Install and configure katello
#
# === Parameters:
#
# $user::               The Katello system user name;
#                       default 'katello'
#
# $group::              The Katello system user group;
#                       default 'katello'
#
# $user_groups::        Extra user groups the Katello user is a part of;
#                       default 'foreman
#
# $oauth_key::          The oauth key for talking to the candlepin API;
#                       default 'katello'
#
# $oauth_secret::       The oauth secret for talking to the candlepin API;
#
# $log_dir::            Location for Katello log files to be placed
#
class katello (

  $user = $katello::params::user,
  $group = $katello::params::group,
  $user_groups = $katello::params::user_groups,

  $oauth_key = $katello::params::oauth_key,
  $oauth_secret = $katello::params::oauth_secret,

  $log_dir = $katello::params::log_dir

  ) inherits katello::params {

  class { 'certs::apache': } ~>
  class { 'katello::install': } ~>
  class { 'certs::katello': } ~>
  class { 'katello::config': } ~>
  class { 'katello::service': } ~>
  Exec['foreman-rake-db:seed']

  class { 'certs::qpid': } ~>
  class { '::certs::pulp_parent': } ~>
  class { 'pulp':
    oauth_key                   => $katello::oauth_key,
    oauth_secret                => $katello::oauth_secret,
    messaging_url               => 'ssl://localhost:5671',
    qpid_ssl_cert_db            => '/etc/pki/katello/nssdb',
    qpid_ssl_cert_password_file => '/etc/katello/nss_db_password-file',
    before                      => Exec['foreman-rake-db:seed']
  }

  class { 'candlepin':
    user_groups       => $katello::user_groups,
    oauth_key         => $katello::oauth_key,
    oauth_secret      => $katello::oauth_secret,
    deployment_url    => 'katello',
    keystore_password => $::certs::candlepin_keystore_password,
    before            => Exec['foreman-rake-db:seed']
  }

  class{ 'elasticsearch':
    before         => Exec['foreman-rake-db:seed']
  }
}
