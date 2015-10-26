# Class to ensure qpid tools package
class qpid::tools {

  package { 'qpid-tools':
    ensure => 'installed',
  }

}
