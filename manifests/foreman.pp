# Handles Foreman certs configuration
class certs::foreman (
    $hostname    = $::certs::node_fqdn,
    $generate    = $::certs::generate,
    $regenerate  = $::certs::regenerate,
    $deploy      = $::certs::deploy,
    $ca          = $::certs::default_ca,
    $client_cert = $::certs::params::foreman_client_cert,
    $client_key  = $::certs::params::foreman_client_key,
    $client_ca   = $::certs::params::foreman_client_ca
  ) inherits certs::params {

  # cert for authentication of puppetmaster against foreman
  cert { "${::certs::foreman::hostname}-foreman-client":
    hostname    => $::certs::foreman::hostname,
    purpose     => client,
    country     => $::certs::country,
    state       => $::certs::state,
    city        => $::certs::sity,
    org         => 'FOREMAN',
    org_unit    => 'PUPPET',
    expiration  => $::certs::expiration,
    ca          => $ca,
    generate    => $generate,
    regenerate  => $regenerate,
    deploy      => $deploy,
  }

  if $deploy {
    pubkey { $client_cert:
      cert => Cert["${::certs::foreman::hostname}-foreman-client"],
    }

    privkey { $client_key:
      cert => Cert["${::certs::foreman::hostname}-foreman-client"],
    } ->

    file { $client_key:
      ensure  => file,
      owner   => 'foreman',
      mode    => '0400',
    }

    pubkey { $client_ca:
      cert => $ca,
    }
  }
}
