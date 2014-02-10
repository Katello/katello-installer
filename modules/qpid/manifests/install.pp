# == Class: qpid::install
#
# Handles Qpid install
#
class qpid::install {

  case $::operatingsystem {
    'Fedora': {
      $packages_to_install = ['qpid-cpp-server','qpid-cpp-client']
    }
    default: {
      $packages_to_install = ['qpid-cpp-server','qpid-cpp-client','qpid-cpp-client-ssl','qpid-cpp-server-ssl']
    }
  }

  package { $packages_to_install:
    ensure => 'installed',
    before => Service['qpidd']
  }

  package {'policycoreutils-python':
    ensure => 'installed'
  }

}

