# Candlepin Service and Initialization
class candlepin::service {

  service { $candlepin::tomcat:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  exec { 'cpinit':
    # tomcat startup is slow - try multiple times (the initialization service is idempotent)
    command => "/usr/bin/wget --timeout=30 --tries=5 --retry-connrefused -qO- http://localhost:8080/candlepin/admin/init >${candlepin::log_dir}/cpinit.log 2>&1 && touch /var/lib/candlepin/cpinit_done",
    require => [Service[$candlepin::tomcat], File[$candlepin::log_dir]],
    creates => '/var/lib/candlepin/cpinit_done'
  }

}
