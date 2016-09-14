# == Define: qpid::router::connector
#
# Configure a qpid router connector
#
# == Parameters
#
# $ssl_profile::    SSL profile to use
#
# $addr::           Address to listen on
#
# $port::           Port to listen on
#
# $sasl_mech::      SASL mechanism to use
#
# $role::           Listener role
#
# $idle_timeout::   Timeout in seconds
#
define qpid::router::connector(
  $addr         = '0.0.0.0',
  $port         = 5672,
  $sasl_mech    = 'ANONYMOUS',
  $role         = undef,
  $ssl_profile  = undef,
  $idle_timeout = undef,
){

  concat::fragment {"qdrouter+connector_${name}.conf":
    target  => $qpid::router::config_file,
    content => template('qpid/router/connector.conf.erb'),
    order   => '03',
  }

}
