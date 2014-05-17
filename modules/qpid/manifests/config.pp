# == Class: qpid::config
#
# Handles Qpid configuration
#
class qpid::config {

  user { 'qpidd':
    ensure => present,
    groups => [$qpid::user_groups],
  }

  file { '/etc/qpid/qpidd.conf':
    ensure  => file,
    content => template('qpid/qpidd.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
