# == Class: qpid::client::params
#
# Default parameter values
#
class qpid::client::params {
  $config_file = '/etc/qpid/qpidc.conf'

  $log_level = 'error+'

  $ssl                     = false
  $ssl_port                = 5671
  $ssl_cert_db             = undef
  $ssl_cert_password_file  = undef
  $ssl_cert_name           = undef

  $client_packages = ['qpid-cpp-client-devel']
}
