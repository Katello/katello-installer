# Katello Services
class katello::service {
  include pulp::service

  service {'katello-jobs':
    ensure      => running,
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
  }
}
