# Certs configurations for Apache
class certs::apache (

  $hostname        = $::certs::node_fqdn,
  $generate        = $::certs::generate,
  $regenerate      = $::certs::regenerate,
  $deploy          = $::certs::deploy,

  $ca              = $::certs::default_ca,
  $apache_cert_name = $::certs::params::apache_cert_name,

  ) inherits certs::params {

  include ::apache

  $apache_cert = "${certs::pki_dir}/certs/${apache_cert_name}.crt"
  $apache_key  = "${certs::pki_dir}/private/${apache_cert_name}.key"

  cert { $apache_cert_name:
    ensure        => present,
    hostname      => $::certs::node_fqdn,
    country       => $::certs::country,
    state         => $::certs::state,
    city          => $::certs::sity,
    org           => $::certs::org,
    org_unit      => $::certs::org_unit,
    expiration    => $::certs::expiration,
    ca            => $ca,
    generate      => $generate,
    regenerate    => $regenerate,
    deploy        => $deploy,
    password_file => $certs::ca_key_password_file,
  }

  if $deploy {

    Cert[$apache_cert_name] ~>
    pubkey { $apache_cert:
      ensure   => present,
      key_pair => Cert[$apache_cert_name]
    } ~>
    privkey { $apache_key:
      ensure    => present,
      key_pair  => Cert[$apache_cert_name]
    } ->
    file { $apache_key:
      owner => $::apache::user,
      group => $::apache::group,
      mode  => '0400',
    } ->
    Service['httpd']

  }
}
