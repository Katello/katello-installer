# Class for handling Puppet cert configuration
class certs::puppet (

  $hostname    = $::certs::node_fqdn,
  $generate    = $::certs::generate,
  $regenerate  = $::certs::regenerate,
  $deploy      = $::certs::deploy,

  $client_cert = $::certs::params::puppet_client_cert,
  $client_key  = $::certs::params::puppet_client_key,
  $ssl_ca_cert = $::certs::params::puppet_ssl_ca_cert

  ) inherits certs::params {

  $puppet_client_cert_name = "${::certs::puppet::hostname}-puppet-client"

  # cert for authentication of puppetmaster against foreman
  cert { $puppet_client_cert_name:
    hostname      => $::certs::puppet::hostname,
    purpose       => client,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::sity,
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

    Cert[$puppet_client_cert_name] ~>
    pubkey { $client_cert:
      key_pair => Cert[$puppet_client_cert_name],
    } ~>
    privkey { $client_key:
      key_pair => Cert[$puppet_client_cert_name],
    } ->
    pubkey { $ssl_ca_cert:
      key_pair => $::certs::server_ca
    } ~>
    file { $client_key:
      ensure  => file,
      owner   => 'puppet',
      mode    => '0400',
    }

  }
}
