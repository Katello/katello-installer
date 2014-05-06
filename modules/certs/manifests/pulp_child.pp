# Pulp Node Certs
class certs::pulp_child (
    $hostname   = $::certs::node_fqdn,
    $generate   = $::certs::generate,
    $regenerate = $::certs::regenerate,
    $deploy     = $::certs::deploy,
    $ca         = $::certs::default_ca
  ) {

  if $deploy {
    pubkey { $pulp::consumers_ca_cert:
      key_pair => $ca,
    } ~>

    pubkey { $pulp::ssl_ca_cert:
      key_pair => $ca
    }

    pubkey { $pulp::child::ssl_cert:
      # Defined in certs::apache module
      key_pair => Cert["${hostname}-apache"],
    }

    privkey { $pulp::child::ssl_key:
      # Defined in certs::apache module
      key_pair => Cert["${hostname}-apache"],
    }
  }
}
