# == Class: qpid::router::service
#
# Handles Qpid Dispatch Router service
#
class qpid::router::service {

  service { 'qdrouterd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
