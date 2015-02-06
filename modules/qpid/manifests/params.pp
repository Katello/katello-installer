# == Class: qpid::params
#
# Default parameter values
#
class qpid::params {
  $auth = false

  $config_file = '/etc/qpid/qpidd.conf'

  $log_level = 'error+'
  $log_to_syslog = true

  $ssl                     = false
  $ssl_port                = 5671
  $ssl_cert_db             = undef
  $ssl_cert_password_file  = undef
  $ssl_cert_name           = undef
  $ssl_require_client_auth = true

  $user_groups = []

  $user = 'qpidd'
  $group = 'qpidd'

  $server_packages = ['qpid-cpp-server', 'qpid-cpp-client', 'python-qpid-qmf', 'python-qpid', 'policycoreutils-python', 'qpid-tools']
}
