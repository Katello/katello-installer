# Katello Config
class katello::qpid (
  $client_cert            = undef,
  $client_key             = undef,
  $katello_user           = $katello::user
){
  if $katello_user == undef {
    fail('katello_user not defined')
  } else {
    Group['qpidd'] ->
    User<|title == $katello_user|>{groups +> 'qpidd'}
  }
  exec { 'create katello entitlments queue':
    command   => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://${::fqdn}:5671' add queue ${katello::params::candlepin_event_queue} --durable",
    unless    => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://${::fqdn}:5671' queues ${katello::params::candlepin_event_queue}",
    path      => '/usr/bin',
    require   => Service['qpidd'],
    logoutput => true,
  }
  exec { 'bind katello entitlments queue to qpid exchange messages that deal with entitlements':
    command   => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://${::fqdn}:5671' bind event ${katello::params::candlepin_event_queue} '*.*'",
    onlyif    => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://${::fqdn}:5671' queues ${katello::params::candlepin_event_queue}",
    path      => '/usr/bin',
    require   => Service['qpidd'],
    logoutput => true,
  }

}
