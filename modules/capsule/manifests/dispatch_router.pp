# == Class: capsule::dispatch_router
#
# Install and configure Qpid Dispatch Router
#
class capsule::dispatch_router (
) {

  class { 'qpid::router': }

  # SSL Certificate Configuration
  class { 'certs::qpid_router':
    require => Class['qpid::router::install'],
  } ~>
  qpid::router::ssl_profile { 'client':
    ca   => $certs::ca_cert,
    cert => $certs::qpid_router::client_cert,
    key  => $certs::qpid_router::client_key,
  } ~>
  qpid::router::ssl_profile { 'server':
    ca   => $certs::ca_cert,
    cert => $certs::qpid_router::server_cert,
    key  => $certs::qpid_router::server_key,
  }

  # Listen for katello-agent clients
  qpid::router::listener { 'clients':
    addr        => $capsule::qpid_router_agent_addr,
    port        => $capsule::qpid_router_agent_port,
    ssl_profile => 'server',
  }

  # Act as hub if pulp master, otherwise connect to hub
  if $capsule::pulp_master {
    qpid::router::listener {'hub':
      addr        => $capsule::qpid_router_hub_addr,
      port        => $capsule::qpid_router_hub_port,
      role        => 'inter-router',
      ssl_profile => 'server',
    }

    # Connect dispatch router to the local qpid
    qpid::router::connector { 'broker':
      addr        => $capsule::qpid_router_broker_addr,
      port        => $capsule::qpid_router_broker_port,
      ssl_profile => 'client',
      role        => 'on-demand',
    }

    qpid::router::link_route_pattern { 'broker-pulp-route':
      prefix    => 'pulp.',
      connector => 'broker',
    }

    qpid::router::link_route_pattern { 'broker-qmf-route':
      prefix    => 'qmf.',
      connector => 'broker',
    }
  } else {
    qpid::router::connector { 'hub':
      addr        => $capsule::parent_fqdn,
      port        => $capsule::qpid_router_hub_port,
      ssl_profile => 'client',
      role        => 'inter-router',
    }

    qpid::router::link_route_pattern { 'hub-pulp-route':
      prefix    => 'pulp.',
    }

    qpid::router::link_route_pattern { 'hub-qmf-route':
      prefix    => 'qmf.',
    }
  }
}
