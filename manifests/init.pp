class qpid (
  $ssl                    = $qpid::params::ssl,
  $ssl_port               = $qpid::params::ssl_port,
  $ssl_cert_db            = $qpid::params::ssl_cert_db,
  $ssl_cert_password_file = $qpid::params::ssl_cert_password_file,
  $ssl_cert_name          = $qpid::params::ssl_cert_name
  ) inherits qpid::params {

  class { 'qpid::install': } ~>
  class { 'qpid::certs': } ~>
  class { 'qpid::config': } ~>
  class { 'qpid::service': } ->
  Class['qpid']

}
