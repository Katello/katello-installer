# Handles Foreman certs configuration
class certs::foreman (

  $hostname       = $::certs::node_fqdn,
  $generate       = $::certs::generate,
  $regenerate     = $::certs::regenerate,
  $deploy         = $::certs::deploy,
  $client_cert    = $::certs::params::foreman_client_cert,
  $client_key     = $::certs::params::foreman_client_key,
  $ssl_ca_cert    = $::certs::params::foreman_ssl_ca_cert

  ) inherits certs::params {

  $client_cert_name = "${::certs::foreman::hostname}-foreman-client"

  # cert for authentication of puppetmaster against foreman
  cert { $client_cert_name:
    hostname      => $::certs::foreman::hostname,
    purpose       => client,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::city,
    org           => 'FOREMAN',
    org_unit      => 'PUPPET',
    expiration    => $::certs::expiration,
    ca            => $::certs::default_ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    password_file => $certs::ca_key_password_file,
  }

  if $deploy {

    Cert[$client_cert_name] ~>
    pubkey { $client_cert:
      key_pair => Cert[$client_cert_name],
    } ~>
    privkey { $client_key:
      key_pair => Cert[$client_cert_name],
    } ->
    pubkey { $ssl_ca_cert:
      key_pair => $::certs::server_ca,
    } ~>
    file { $client_key:
      ensure => file,
      owner  => 'foreman',
      mode   => '0400',
    }
  }
}
