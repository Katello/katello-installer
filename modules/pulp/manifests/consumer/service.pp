# Pulp Consumer Service Packages
class pulp::consumer::service {
  service { 'goferd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
