# Install and Configure gutterball
#
# == Parameters:
#
# $gutterball_conf_file::   Gutterball configuration file
#                           default '/etc/gutterball/gutterball_conf_file'
#
# $dbname::                 The Gutterball database name;
#                           default 'gutterball'
#
# $dbuser::                 The Gutterball database username;
#                           default 'gutterball'
#
# $dbpassword::             The Gutterball database password;
#                           default 'redhat'
#
# $tomcat::                 The system tomcat to use, tomcat6 on RHEL6 and tomcat on most Fedoras
#
# $keystore_file::          Path to keystore file
#
# $keystore_password::      Password for keystore
#
# $truststore_file::        Path to truststore file
#
# $truststore_password::    Password for trutstore
#
# $amqp_broker_host::       AMQP service's fqdn
#
# $amqp_broker_port::       AMQP service's port number
#
class gutterball (
  $amqp_broker_host     = $::fqdn,
  $amqp_broker_port     = '5671',
  $gutterball_conf_file = $::gutterball::params::gutterball_conf_file,
  $dbname               = $::gutterball::params::dbname,
  $dbuser               = $::gutterball::params::dbuser,
  $dbpassword           = $::gutterball::params::dbpassword,
  $keystore_file        = $::gutterball::params::keystore_file,
  $keystore_password    = $::gutterball::params::keystore_password,
  $truststore_file      = $::gutterball::params::truststore_file,
  $truststore_password  = $::gutterball::params::truststore_password,
  $tomcat               = $::gutterball::params::tomcat,
) inherits gutterball::params {
  validate_absolute_path([$keystore_file, $truststore_file])

  class { '::gutterball::install': } ~>
  class { '::gutterball::config': } ~>
  class { '::gutterball::database': } ~>
  class { '::gutterball::service': } ~>
  Class['gutterball']
}
