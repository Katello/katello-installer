# Install and Configure gutterball
#
# == Parameters:
#
# $gutterball_conf_file::   Gutterball configuration file
#                           default '/etc/gutterball/gutterball_conf_file'
#
# $dbuser::                 The Gutterball database username;
#                           default 'gutterball'
#
# $dbpassword::             The Gutterball database password;
#                           default 'redhat'
#
# $tomcat::                 The system tomcat to use, tomcat6 on RHEL6 and tomcat on most Fedoras
#
# $keystore_password::      Password to keystore and trutstore
#
# $amqp_broker_host::      AMQP service's fqdn
#
# $amqp_broker_port::      AMQP service's port number
#
class gutterball (
  $amqp_broker_host = $::fqdn,
  $amqp_broker_port = '5671',
  $gutterball_conf_file = $gutterball::params::gutterball_conf_file,
  $dbuser = $gutterball::params::dbuser,
  $dbpassword = $gutterball::params::dbpassword,
  $keystore_password = $gutterball::params::keystore_password,
  $tomcat = $gutterball::params::tomcat,
) inherits gutterball::params {

  class { 'gutterball::install': } ~>
  class { 'gutterball::config':
    amqp_broker_host  => $amqp_broker_host,
    amqp_broker_port  => $amqp_broker_port,
    keystore_password => $keystore_password
  } ~>
  class { 'gutterball::database': } ~>
  class { 'gutterball::service': } ~>
  Class['gutterball']

}
