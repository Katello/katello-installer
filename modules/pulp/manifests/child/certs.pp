class pulp::child::certs (
    $hostname   = $::certs::node_fqdn,
    $generate   = $::certs::generate,
    $regenerate = $::certs::regenerate,
    $deploy     = $::certs::deploy,
    $ca         = $::certs::default_ca
  ) {

  if $deploy {
    pubkey { $pulp::consumers_ca_cert:
      cert => $ca,
    } ~>

    pubkey { $pulp::ssl_ca_cert:
      # Defined in apache::certs module
      cert => Cert["${pulp::child::certs::hostname}-ssl"],
    }
  }
}
