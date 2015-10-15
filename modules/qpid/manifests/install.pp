# == Class: qpid::install
#
# Handles Qpid install
#
class qpid::install {

  include ::qpid::tools

  package { $qpid::server_packages:
    ensure => 'installed',
    before => Service['qpidd'],
  }

}
