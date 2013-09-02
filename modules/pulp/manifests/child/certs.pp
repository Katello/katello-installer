class pulp::child::certs (
    $hostname = $::certs::node_fqdn,
    $generate = $::certs::generate,
    $regenerate = $::certs::regenerate,
    $deploy   = $::certs::deploy,
    $ca       = $::certs::default_ca,
    $nodes_cert = '/etc/pki/pulp/nodes/local.crt'
  ) {

  # cert for nodes authenitcation
  cert { "${pulp::child::certs::hostname}-child-cert":
    # TODO: override common name so that it can't be used as server cert
    hostname    => $pulp::child::certs::hostname,
    common_name => 'admin:admin:0',
    purpose     => client,
    country     => $::certs::country,
    state       => $::certs::state,
    city        => $::certs::sity,
    org         => 'PULP',
    org_unit    => 'NODES',
    expiration  => $::certs::expiration,
    ca          => $ca,
    generate    => $generate,
    regenerate    => $regenerate,
    deploy      => $deploy,
  }

  if $deploy {
    # for the pulp agent to be able to talk to the pulp server
    key_bundle { $pulp::child::certs::nodes_cert:
      cert => Cert["${pulp::child::certs::hostname}-child-cert"],
    }

    # for the pulp agent to be able to listen to the master pulp qpid
    key_bundle { $pulp::child::consumer_bundle:
      pubkey => '/etc/pki/consumer/cert.pem',
      privkey => '/etc/pki/consumer/key.pem'
    }

    pubkey { $pulp::consumers_ca_cert:
      cert => $ca,
    } ~>

    pubkey { $pulp::ssl_ca_cert:
      # Defined in apache::ssl module
      cert => Cert["${pulp::child::certs::hostname}-ssl"],
    }
  }
}
