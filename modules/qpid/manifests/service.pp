class qpid::service {
  service {'qpidd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }
}
