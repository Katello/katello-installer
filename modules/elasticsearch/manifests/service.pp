# Elasticsearch service
class elasticsearch::service {
  service { 'elasticsearch':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
