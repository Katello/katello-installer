# == Class: qpid::install
#
# Handles Qpid install
#
class qpid::install {

  include ::qpid::tools

  package { $qpid::server_packages:
    ensure => $qpid::version,
    before => Service['qpidd'],
  }

  if ($qpid::server_store) {
    package { $qpid::server_store_package:
      ensure => $qpid::version,
      before => Service['qpidd'],
    }
  }
}
