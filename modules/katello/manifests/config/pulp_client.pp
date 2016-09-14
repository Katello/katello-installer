#Katello Pulp Client config
class katello::config::pulp_client {

  class { '::certs::pulp_client': }

  foreman_config_entry { 'pulp_client_cert':
    value          => $::certs::pulp_client::client_cert,
    ignore_missing => false,
    require        => [Class['::certs::pulp_client'], Exec['foreman-rake-db:seed']],
  }

  foreman_config_entry { 'pulp_client_key':
    value          => $::certs::pulp_client::client_key,
    ignore_missing => false,
    require        => [Class['::certs::pulp_client'], Exec['foreman-rake-db:seed']],
  }
}

