# Class for setting up Foreman client certs
class katello_devel::foreman_certs (

  $hostname       = $::certs::node_fqdn,
  $generate       = $::certs::generate,
  $regenerate     = $::certs::regenerate,
  $deploy         = $::certs::deploy,

  ) {

  $client_cert_name = "${hostname}-foreman-client"
  $client_cert      = "${::certs::pki_dir}/certs/${client_cert_name}.crt"
  $client_key       = "${::certs::pki_dir}/private/${client_cert_name}.key"
  $ssl_ca_cert      = $::certs::ca_cert

  # cert for authentication of puppetmaster against foreman
  cert { $client_cert_name:
    hostname      => $hostname,
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

  Cert[$client_cert_name] ~>
    pubkey { $client_cert:
    key_pair => Cert[$client_cert_name],
  } ~>
    privkey { $client_key:
    key_pair => Cert[$client_cert_name],
  } ~>
  file { $client_key:
    group => $katello_devel::group,
    owner => 'root',
    mode  => '0440'
  }

}
