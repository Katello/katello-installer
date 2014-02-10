# == Class: qpid
#
# Install and configure candlepin
#
# ===  Parameters:
#
# $ssl::                      Use SSL with Qpid;
#                             default: false
#                             type: boolean
#
# $ssl_port::                 SSL port to use;
#                             default: 5671
#                             type: string
#
# $ssl_cert_db::              The SSL cert database to use
#                             type: string
#
# $ssl_cert_password_file::   The SSL cert password file
#                             type: string
#
# $ssl_cert_name::            The SSL cert name
#                             string: string
#
# $user_groups::              Additional user groups to add the qpidd user to
#
class qpid (

  $ssl                    = $qpid::params::ssl,
  $ssl_port               = $qpid::params::ssl_port,
  $ssl_cert_db            = 'UNSET',
  $ssl_cert_password_file = 'UNSET',
  $ssl_cert_name          = 'UNSET',

  $user_groups            = $qpid::params::user_groups

  ) inherits qpid::params {

  class { 'qpid::install': } ~>
  class { 'qpid::config': } ~>
  class { 'qpid::service': } ->
  Class['qpid']

}
