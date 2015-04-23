# == Class: katello_devel
#
# Install and configure Katello for development
#
# === Parameters:
#
# $user::                 The Katello system user name
#
# $deployment_dir::       Location to deploy Katello to in development
#
# $oauth_key::            The oauth key for talking to the candlepin API;
#                         default 'katello'
#
# $oauth_secret::         The oauth secret for talking to the candlepin API;
#
# $post_sync_token::      The shared secret for pulp notifying katello about
#                         completed syncs
#
# $use_passenger::        Whether to use Passenger in development;
#                         default false
#
# $db_type::              The database type; 'postgres' or 'sqlite'
#
# $use_rvm::              If set to true, will install and configure RVM
#
# $rvm_ruby::             The default Ruby version to use with RVM
#
# $initial_organization:: Initial organization to be created
#
# $initial_location::     Initial location to be created
#
# $admin_password::       Admin user password for Web application
#
class katello_devel (

  $user   = $katello_devel::params::user,

  $oauth_key = $katello_devel::params::oauth_key,
  $oauth_secret = $katello_devel::params::oauth_secret,

  $deployment_dir = $katello_devel::params::deployment_dir,

  $post_sync_token = $katello_devel::params::post_sync_token,

  $db_type = $katello_devel::params::db_type,

  $use_rvm = $katello_devel::params::use_rvm,
  $rvm_ruby = $katello_devel::params::rvm_ruby,

  $use_passenger = $katello_devel::params::use_passenger,

  $initial_organization = $katello_devel::params::initial_organization,
  $initial_location = $katello_devel::params::initial_location,
  $admin_password = $katello_devel::params::admin_password,

  ) inherits katello_devel::params {

  $group = $user

  $changeme = '$6$lb06/IMy$nZhR3LkR2tUunTQm68INFWMyb/8VA2vfYq0/fRzLoKSfuri.vvtjeLJf9V.wuHzw92.aw8NgUlJchMy/qK25x.'

  user { $katello_devel::user:
    ensure     => present,
    managehome => true,
    password   => $changeme,
  } ~>
  group { $katello_devel::group:
    ensure => present
  }

  Class['certs'] ~>
  class { 'certs::apache': } ~>
  class { 'katello_devel::apache': } ~>
  class { 'certs::qpid':
    require => Class['qpid::install']
  } ~>
  class { 'katello_devel::install': } ~>
  class { 'katello_devel::config': } ~>
  class { 'katello_devel::database': } ~>
  class { 'katello_devel::foreman_certs': } ~>
  class { 'katello_devel::setup':
    require => [
      Class['pulp'],
      Class['candlepin'],
      Class['elasticsearch']
    ]
  }


  Class['certs'] ~>
  Class['certs::qpid'] ~>
  class { 'certs::candlepin': } ~>
  class { 'candlepin':
    user_groups       => $katello_devel::group,
    oauth_key         => $katello_devel::oauth_key,
    oauth_secret      => $katello_devel::oauth_secret,
    deployment_url    => 'katello',
    ca_key            => $certs::ca_key,
    ca_cert           => $certs::ca_cert_stripped,
    keystore_password => $::certs::candlepin::keystore_password,
    require           => Class['katello_devel::database']
  }

  Class['certs'] ~>
  Class['certs::qpid'] ~>
  class { 'certs::pulp_parent': } ~>
  class { 'pulp':
    oauth_key                   => $katello_devel::oauth_key,
    oauth_secret                => $katello_devel::oauth_secret,
    messaging_url               => 'ssl://localhost:5671',
    qpid_ssl_cert_db            => $certs::nss_db_dir,
    qpid_ssl_cert_password_file => $certs::qpid::nss_db_password_file,
    messaging_ca_cert           => $certs::pulp_parent::messaging_ca_cert,
    messaging_client_cert       => $certs::pulp_parent::messaging_client_cert,
    consumers_ca_cert           => $certs::ca_cert,
    consumers_ca_key            => $certs::ca_key,
    consumers_crl               => $candlepin::crl_file,
  } ~>
  class { 'qpid::client':
    ssl                    => true,
    ssl_cert_name          => 'broker',
    ssl_cert_db            => $certs::nss_db_dir,
    ssl_cert_password_file => $certs::qpid::nss_db_password_file,
  } ~>
  class { 'katello::qpid':
    client_cert  => $certs::qpid::client_cert,
    client_key   => $certs::qpid::client_key,
    katello_user => $user
  }

  class{ 'elasticsearch': }
}
