# Handles Foreman Proxy cert configuration
class certs::foreman_proxy (

  $hostname   = $::certs::node_fqdn,
  $generate   = $::certs::generate,
  $regenerate = $::certs::regenerate,
  $deploy     = $::certs::deploy,
  $ca         = $::certs::default_ca,
  $proxy_cert = $::certs::params::foreman_proxy_cert,
  $proxy_key  = $::certs::params::foreman_proxy_key,
  $proxy_ca_cert = $::certs::params::foreman_proxy_ca_cert

  ) inherits certs::params {

  $proxy_cert_name = "${::certs::foreman_proxy::hostname}-foreman-proxy"

  # cert for ssl of foreman-proxy
  cert { $proxy_cert_name:
    hostname      => $::certs::foreman_proxy::hostname,
    purpose       => server,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::sity,
    org           => 'FOREMAN',
    org_unit      => 'SMART_PROXY',
    expiration    => $::certs::expiration,
    ca            => $ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    password_file => $certs::ca_key_password_file,
  }

  if $deploy {

    Cert[$proxy_cert_name] ~>
    pubkey { $proxy_cert:
      key_pair => Cert[$proxy_cert_name],
    } ~>
    privkey { $proxy_key:
      key_pair => Cert[$proxy_cert_name],
    } ->
    pubkey { $proxy_ca_cert:
      key_pair => $ca
    } ~>
    file { $proxy_key:
      ensure  => file,
      owner   => 'foreman-proxy',
      group   => $certs::group,
      mode    => '0400'
    } ~>
    Service['foreman-proxy']

  }
}
