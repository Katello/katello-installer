# Pulp Node Certs
class certs::pulp_child (
    $hostname   = $::certs::node_fqdn,
    $generate   = $::certs::generate,
    $regenerate = $::certs::regenerate,
    $deploy     = $::certs::deploy,
  ) {

  cert { "${::certs::pulp_child::hostname}-qpid-client-cert":
    hostname      => $::certs::pulp_child::hostname,
    common_name   => 'pulp-qpid-client-cert',
    purpose       => client,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::city,
    org           => 'PULP',
    org_unit      => $::certs::org_unit,
    expiration    => $::certs::expiration,
    ca            => $::certs::default_ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    password_file => $certs::ca_key_password_file,
  }

  if $deploy {
    pubkey { $pulp::consumers_ca_cert:
      key_pair => $::certs::default_ca,
    } ~>

    pubkey { $pulp::ssl_ca_cert:
      key_pair => $::certs::default_ca
    }

    pubkey { $pulp::child::server_ca_cert:
      key_pair => $::certs::server_ca
    }

    pubkey { $pulp::child::ssl_cert:
      # Defined in certs::apache module
      key_pair => Cert["${hostname}-apache"],
    }

    privkey { $pulp::child::ssl_key:
      # Defined in certs::apache module
      key_pair => Cert["${hostname}-apache"],
    }

    Cert["${::certs::pulp_child::hostname}-qpid-client-cert"] ~>
    key_bundle { $pulp::messaging_client_cert:
      key_pair => Cert["${::certs::pulp_child::hostname}-qpid-client-cert"],
    } ~>
    file { $pulp::messaging_client_cert:
      owner => 'apache',
      group => 'apache',
      mode  => '0640',
    }

  }
}
