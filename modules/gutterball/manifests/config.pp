# Configuration for Candlepin
class gutterball::config(
  $amqp_broker_host = $::fqdn,
  $amqp_broker_port = '5671',
  $dbuser = $gutterball::dbuser,
  $dbpass = $gutterball::dbpassword,
  $keystore_password = $gutterball::keystore_password_file,
){
  user { 'gutterball':
    ensure => present
  }->
  group {'gutterball':
    ensure => present,
  }

  file { '/etc/gutterball':
    ensure => directory,
    mode   => '0775',
    owner  => 'root',
    group  => 'tomcat',
  }

  file { $gutterball::gutterball_conf_file:
    ensure  => file,
    content => template('gutterball/gutterball.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }
}
