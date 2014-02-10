# == Class: qpid::config
#
# Handles Qpid configuration
#
class qpid::config {

  user { 'qpidd':
    ensure => present,
    groups => [$qpid::user_groups],
  }

  file { '/etc/qpidd.conf':
    content => template('qpid/etc/qpidd.conf.erb')
  }

}
