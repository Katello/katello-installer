# == Define: qpid::router::link_route_pattern
#
# Configure a link route pattern
#
# == Parameters
#
# $prefix::     Prefix to use
#
# $connector::  Connector for this link route pattern
#
define qpid::router::link_route_pattern(
  $prefix    = 'queue.',
  $connector = '',
){

  concat_fragment {"qdrouter+link_route_pattern_${name}.conf":
    content => template('qpid/router/link_route_pattern.conf.erb'),
  }

}
