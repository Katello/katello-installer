# == Class: qpid::router:install
#
# Installs Qpid router packages
#
class qpid::router::install {
  package { $qpid::router::router_packages:
    ensure => 'installed',
  }
}
