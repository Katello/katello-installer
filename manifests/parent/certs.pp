class pulp::parent::certs (
    $hostname = $::certs::node_fqdn,
    $generate = $::certs::generate,
    $regenerate = $::certs::regenerate,
    $deploy   = $::certs::deploy,
    $ca       = $::certs::default_ca,
    $nodes_cert = '/etc/pki/pulp/nodes/node.crt'
  ) {

  # cert for nodes authenitcation
  cert { "${pulp::parent::certs::hostname}-parent-cert":
    hostname    => $pulp::parent::certs::hostname,
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
    regenerate    => $regenerate,
    deploy      => $deploy,
  }

  if $deploy {
    key_bundle { $pulp::parent::certs::nodes_cert:
      cert => Cert["${pulp::parent::certs::hostname}-parent-cert"],
    } ~>
    # TODO: temporary until we switch to new modules for setting parent
    exec { 'reload-pulp':
      command             => "service httpd reload",
      path                => ["/sbin", "/usr/sbin", "/bin", "/usr/bin"],
      refreshonly => true,
    }
  }
}
