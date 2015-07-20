# Pulp Node Service
class pulp::child::service {
  service { 'goferd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
