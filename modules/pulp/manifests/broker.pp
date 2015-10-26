# Set up the broker
class pulp::broker {
  if $pulp::manage_broker {
    if $pulp::messaging_transport == 'qpid' {
      include ::qpid
      $broker_service = 'qpidd'
    } elsif $pulp::messaging_transport == 'rabbitmq' {
      include ::rabbitmq
      $broker_service = 'rabbitmq-server'
    }

    Service[$broker_service] -> Service['pulp_celerybeat']
    Service[$broker_service] -> Service['pulp_workers']
    Service[$broker_service] -> Service['pulp_resource_manager']
    Service[$broker_service] -> Exec['migrate_pulp_db']
  } else {
    if $pulp::messaging_transport == 'qpid' {
      include ::qpid::tools

      Class['qpid::tools'] -> Class['pulp::service']
    }
  }
}
