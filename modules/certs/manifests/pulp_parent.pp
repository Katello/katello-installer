# Pulp Master Certs configuration
class certs::pulp_parent (

  $hostname   = $::certs::node_fqdn,
  $generate   = $::certs::generate,
  $regenerate = $::certs::regenerate,
  $deploy     = $::certs::deploy,

  $nodes_cert_dir   = $certs::params::nodes_cert_dir,
  $nodes_cert_name  = $certs::params::nodes_cert_name,

  $messaging_ca_cert     = $certs::ca_cert,
  $messaging_client_cert = $certs::params::messaging_client_cert

  ) inherits pulp::params {

  # cert for nodes authenitcation
  cert { "${::certs::pulp_parent::hostname}-parent-cert":
    hostname      => $certs::pulp_parent::hostname,
    common_name   => 'pulp-child-node-cert',
    purpose       => client,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::sity,
    org           => 'PULP',
    org_unit      => 'NODES',
    expiration    => $::certs::expiration,
    ca            => $::certs::default_ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    password_file => $certs::ca_key_password_file,
  }

  cert { "${::certs::pulp_parent::hostname}-qpid-client-cert":
    hostname      => $::certs::pulp_parent::hostname,
    common_name   => 'pulp-qpid-client-cert',
    purpose       => client,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::sity,
    org           => 'PULP',
    org_unit      => $::certs::org_unit,
    expiration    => $::certs::expiration,
    ca            => $::certs::default_ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    password_file => $certs::ca_key_password_file,
  }

  if $deploy {

    Cert["${::certs::pulp_parent::hostname}-parent-cert"] ~>
    file { $nodes_cert_dir:
      ensure  => directory,
      owner   => $certs::user,
      group   => $certs::group,
      mode    => '0755',
      require => Package['pulp-server'],
    } ->
    key_bundle { "${nodes_cert_dir}/${::certs::pulp_parent::nodes_cert_name}":
      key_pair => Cert["${::certs::pulp_parent::hostname}-parent-cert"],
    }

    Cert["${::certs::pulp_parent::hostname}-qpid-client-cert"] ~>
    key_bundle { $messaging_client_cert:
      key_pair => Cert["${::certs::pulp_parent::hostname}-qpid-client-cert"],
    } ~>
    file { $messaging_client_cert:
      owner => 'apache',
      group => 'apache',
      mode  => '0640',
    } -> Class['pulp::config']

  }

}
