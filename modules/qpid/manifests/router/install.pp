# == Class: qpid::router:install
#
# Installs Qpid router packages
#
class qpid::router::install {
  package { 'qpid-dispatch-router':
    ensure => 'installed',
  }
}
