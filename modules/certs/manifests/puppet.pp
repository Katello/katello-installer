class certs::puppet (
    $hostname    = $::certs::node_fqdn,
    $generate    = $::certs::generate,
    $regenerate  = $::certs::regenerate,
    $deploy      = $::certs::deploy,
    $ca          = $::certs::default_ca,
    $client_cert = $::certs::params::puppet_client_cert,
    $client_key  = $::certs::params::puppet_client_key,
    $client_ca   = $::certs::params::puppet_client_ca
  ) inherits certs::params {

  # cert for authentication of puppetmaster against foreman
  cert { "${::certs::puppet::hostname}-puppet-client":
    hostname    => $::certs::puppet::hostname,
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
      cert => Cert["${::certs::puppet::hostname}-puppet-client"],
    }

    privkey { $client_key:
      cert => Cert["${::certs::puppet::hostname}-puppet-client"],
    } ->

    file { $client_key:
      owner => "puppet",
      mode  => "0400",
    }

    pubkey { $client_ca:
      cert => $ca,
    }
  }
}
