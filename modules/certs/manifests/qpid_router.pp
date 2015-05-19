# Constains certs specific configurations for qpid dispatch router
class certs::qpid_router(
  $hostname               = $::certs::node_fqdn,
  $generate               = $::certs::generate,
  $regenerate             = $::certs::regenerate,
  $deploy                 = $::certs::deploy,
  $server_cert            = $::certs::qpid_router_server_cert,
  $client_cert            = $::certs::qpid_router_client_cert,
  $server_key             = $::certs::qpid_router_server_key,
  $client_key             = $::certs::qpid_router_client_key,
  $owner                  = $::certs::qpid_router_owner,
  $group                  = $::certs::qpid_router_group,
) inherits certs::params {

  $server_keypair = "${hostname}-qpid-router-server"
  $client_keypair = "${hostname}-qpid-router-client"

  cert { $server_keypair:
    ensure        => present,
    hostname      => $hostname,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::sity,
    org           => 'dispatch server',
    org_unit      => $::certs::org_unit,
    expiration    => $::certs::expiration,
    ca            => $::certs::default_ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    purpose       => server,
    password_file => $certs::ca_key_password_file,
  }

  cert { $client_keypair:
    ensure        => present,
    hostname      => $hostname,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::sity,
    org           => 'dispatch client',
    org_unit      => $::certs::org_unit,
    expiration    => $::certs::expiration,
    ca            => $::certs::default_ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    purpose       => client,
    password_file => $certs::ca_key_password_file,
  }

  if $deploy {
    Cert[$server_keypair] ~>
    privkey { $server_key:
      key_pair => Cert[$server_keypair]
    } ~>
    file { $server_key:
      owner => $owner,
      group => $group,
      mode  => '0640',
    } ~>
    pubkey { $server_cert:
      key_pair => Cert[$server_keypair]
    } ~>
    file { $server_cert:
      owner => $owner,
      group => $group,
      mode  => '0640',
    }

    Cert[$client_keypair] ~>
    privkey { $client_key:
      key_pair => Cert[$client_keypair]
    } ~>
    file { $client_key:
      owner => $owner,
      group => $group,
      mode  => '0640',
    } ~>
    pubkey { $client_cert:
      key_pair => Cert[$client_keypair]
    } ~>
    file { $client_cert:
      owner => $owner,
      group => $group,
      mode  => '0640',
    }
  }
}
