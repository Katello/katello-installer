# Pulp Master Certs configuration
class certs::pulp_parent (
    $hostname = $::certs::node_fqdn,
    $generate = $::certs::generate,
    $regenerate = $::certs::regenerate,
    $deploy   = $::certs::deploy,
    $ca       = $::certs::default_ca,
    $nodes_cert = '/etc/pki/pulp/nodes/node.crt',
    $messaging_ca_cert = $pulp::params::messaging_ca_cert,
    $messaging_client_cert = $pulp::params::messaging_client_cert
  ) inherits pulp::params {

  # cert for nodes authenitcation
  cert { "${::certs::pulp_parent::hostname}-parent-cert":
    hostname    => $certs::pulp_parent::hostname,
    common_name => 'pulp-child-node-cert',
    purpose     => client,
    country     => $::certs::country,
    state       => $::certs::state,
    city        => $::certs::sity,
    org         => 'PULP',
    org_unit    => 'NODES',
    expiration  => $::certs::expiration,
    ca          => $ca,
    generate    => $generate,
    regenerate  => $regenerate,
    deploy      => $deploy,
  }

  cert { "${::certs::pulp_parent::hostname}-qpid-client-cert":
    hostname    => $::certs::pulp_parent::hostname,
    common_name => 'pulp-qpid-client-cert',
    purpose     => client,
    country     => $::certs::country,
    state       => $::certs::state,
    city        => $::certs::sity,
    org         => 'PULP',
    org_unit    => $::certs::org_unit,
    expiration  => $::certs::expiration,
    ca          => $ca,
    generate    => $generate,
    regenerate  => $regenerate,
    deploy      => $deploy,
  }

  if $deploy {
    key_bundle { $::certs::pulp_parent::nodes_cert:
      cert => Cert["${::certs::pulp_parent::hostname}-parent-cert"],
    }

    key_bundle { $messaging_client_cert:
      cert => Cert["${::certs::pulp_parent::hostname}-qpid-client-cert"],
    } ~>
    file { $messaging_client_cert:
      owner   => 'apache',
      group   => 'apache',
      mode    => '0640',
    }
  }
}
