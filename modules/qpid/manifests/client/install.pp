# == Class: qpid::client:install
#
# Installs Qpid client packages
#
class qpid::client::install {
  package { $qpid::client::client_packages:
    ensure => 'installed',
  }
}
