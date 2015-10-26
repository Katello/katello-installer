# Configuration for Candlepin
class gutterball::config(
  $amqp_broker_host  = $::gutterball::amqp_broker_host,
  $amqp_broker_port  = $::gutterball::amqp_broker_port,
  $dbuser            = $::gutterball::dbuser,
  $dbpass            = $::gutterball::dbpassword,
  $keystore_password = $::gutterball::keystore_password,
){

  file { '/etc/gutterball':
    ensure => directory,
    mode   => '0775',
    owner  => 'root',
    group  => 'tomcat',
  }

  file { $::gutterball::gutterball_conf_file:
    ensure  => file,
    content => template('gutterball/gutterball.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
}
