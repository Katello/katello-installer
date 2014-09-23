# == Class: qpid::client:install
#
# Installs Qpid client packages
#
class qpid::client::install {
  package { ['qpid-cpp-client-devel']:
    ensure => 'installed'
  }
}
