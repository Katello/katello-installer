# == Class: qpid::install
#
# Handles Qpid install
#
class qpid::install {

  package { $qpid::server_packages:
    ensure => 'installed',
    before => Service['qpidd'],
  }

}
