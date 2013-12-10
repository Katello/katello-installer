class katello_installer::foreman_certs (
    $hostname    = $::certs::node_fqdn,
    $generate    = $::certs::generate,
    $regenerate  = $::certs::regenerate,
    $deploy      = $::certs::deploy,
    $ca          = $::certs::default_ca,
    $client_cert = $::katello_installer::params::foreman_client_cert,
    $client_key  = $::katello_installer::params::foreman_client_key,
    $client_ca   = $::katello_installer::params::foreman_client_ca
  ) {

  # cert for authentication of puppetmaster against foreman
  cert { "${::katello_installer::foreman_certs::hostname}-foreman-client":
    hostname    => $::katello_installer::foreman_certs::hostname,
    purpose     => client,
    country     => $::certs::country,
    state       => $::certs::state,
    city        => $::certs::sity,
    org         => 'FOREMAN',
    org_unit    => 'PUPPET',
    expiration  => $::certs::expiration,
    ca          => $ca,
    generate    => $generate,
    regenerate    => $regenerate,
    deploy      => $deploy,
  }

  if $deploy {
    pubkey { $client_cert:
      cert => Cert["${::katello_installer::foreman_certs::hostname}-foreman-client"],
    }

    privkey { $client_key:
      cert => Cert["${::katello_installer::foreman_certs::hostname}-foreman-client"],
    } ->

    file { $client_key:
      owner => "foreman",
      mode => "0400"
    }

    pubkey { $client_ca:
      cert => $ca,
    }
  }
}
