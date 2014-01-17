class certs::foreman_proxy (
    $hostname   = $::certs::node_fqdn,
    $generate   = $::certs::generate,
    $regenerate = $::certs::regenerate,
    $deploy     = $::certs::deploy,
    $ca         = $::certs::default_ca,
    $proxy_cert = $::certs::params::foreman_proxy_cert,
    $proxy_key  = $::certs::params::foreman_proxy_key,
    $proxy_ca   = $::certs::params::foreman_proxy_ca
  ) inherits certs::params {

  # cert for ssl of foreman-proxy
  cert { "${::certs::foreman_proxy::hostname}-foreman-proxy":
    hostname    => $::certs::foreman_proxy::hostname,
    purpose     => server,
    country     => $::certs::country,
    state       => $::certs::state,
    city        => $::certs::sity,
    org         => 'FOREMAN',
    org_unit    => 'SMART_PROXY',
    expiration  => $::certs::expiration,
    ca          => $ca,
    generate    => $generate,
    regenerate  => $regenerate,
    deploy      => $deploy,
  }

  if $deploy {
    pubkey { $proxy_cert:
      cert => Cert["${::certs::foreman_proxy::hostname}-foreman-proxy"],
    }

    privkey { $proxy_key:
      cert => Cert["${::certs::foreman_proxy::hostname}-foreman-proxy"],
    } ->

    file { $proxy_key:
      owner => "foreman-proxy",
      mode  => "0400"
    }

    pubkey { $proxy_ca:
      cert => $ca,
    }
  }
}
