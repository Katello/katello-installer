class qpid::install {

  package { ['qpid-cpp-server',
             'qpid-cpp-client',
             'qpid-cpp-client-ssl',
             'qpid-cpp-server-ssl',
             'policycoreutils-python']:
    ensure => present,
  }

}
