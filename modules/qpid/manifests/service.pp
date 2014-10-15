# == Class: qpid::service
#
# Handles Qpid service
#
class qpid::service {

  service { 'qpidd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
