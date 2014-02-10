# Katello Services
class katello::service {
  include pulp::service

  service {'katello-jobs':
    ensure      => running,
    require     => Exec['foreman-rake-db:migrate'],
    before      => Service[httpd],
    enable      => true,
    hasstatus   => true,
    hasrestart  => true,
  }
}
