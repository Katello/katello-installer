# == Class: qpid
#
# Install and configure Qpid
#
# ===  Parameters:
# $auth::                     Use SASL authentication
#                             type:boolean
#
# $config_file::              Location of qpid configuration file
#                             type:string
#
# $log_level::                Logging level
#                             type:string
#
# $log_to_syslog::            Log to syslog or not
#                             type:boolean
#
# $interface::                Interface to listen on
#
# $server_store::             Install a Qpid message store
#                             type:boolean
#
# $server_store_package::     Package name for the Qpid message store
#
# $ssl::                      Use SSL with Qpid
#                             type:boolean
#
# $ssl_port::                 SSL port to use
#                             type:string
#
# $ssl_cert_db::              The SSL cert database to use
#                             type:string
#
# $ssl_cert_password_file::   The SSL cert password file
#                             type:string
#
# $ssl_cert_name::            The SSL cert name
#                             type:string
#
# $ssl_require_client_auth::  Require client SSL authentication
#                             type:boolean
#
# $user_groups::              Additional user groups to add the qpidd user to
#                             type:array
#
# $server_packages::          List of server packages to install
#                             type:array
#
class qpid (
  $auth                    = $qpid::params::auth,
  $config_file             = $qpid::params::config_file,
  $log_level               = $qpid::params::log_level,
  $log_to_syslog           = $qpid::params::log_to_syslog,
  $interface               = $qpid::params::interface,
  $server_store            = $qpid::params::server_store,
  $server_store_package    = $qpid::params::server_store_package,
  $ssl                     = $qpid::params::ssl,
  $ssl_port                = $qpid::params::ssl_port,
  $ssl_cert_db             = $qpid::params::ssl_cert_db,
  $ssl_cert_password_file  = $qpid::params::ssl_cert_password_file,
  $ssl_cert_name           = $qpid::params::ssl_cert_name,
  $ssl_require_client_auth = $qpid::params::ssl_require_client_auth,
  $user_groups             = $qpid::params::user_groups,
  $server_packages         = $qpid::params::server_packages,
) inherits qpid::params {

  validate_string($log_level)
  validate_bool($ssl, $auth, $log_to_syslog)
  validate_array($user_groups)
  validate_array($server_packages)

  if $ssl {
    validate_bool($ssl_require_client_auth)
    validate_re($ssl_port, '^\d+$')
    validate_string($ssl_cert_name)
    validate_absolute_path($ssl_cert_db, $ssl_cert_password_file)
  }

  class { '::qpid::install': } ~>
  class { '::qpid::config': } ~>
  class { '::qpid::service': } ->
  Class['qpid']
}
