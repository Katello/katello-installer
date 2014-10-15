# Pulp Master Service
class pulp::service {

  service {'pulp_celerybeat':
    ensure     => running,
    require    => [Service[mongodb], Service[qpidd]],
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  service {'pulp_workers':
    ensure     => running,
    require    => [Service[mongodb], Service[qpidd]],
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    status     => 'service pulp_workers status | grep "node reserved_resource_worker"',
  }

  service {'pulp_resource_manager':
    ensure     => running,
    require    => [Service[mongodb], Service[qpidd]],
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    status     => 'service pulp_resource_manager status | grep "node resource_manager"',
  }

}
