# Certs configurations for Apache
class certs::apache (

  $hostname        = $::certs::node_fqdn,
  $generate        = $::certs::generate,
  $regenerate      = $::certs::regenerate,
  $deploy          = $::certs::deploy,
  ) inherits certs::params {

  $apache_cert_name = "${hostname}-apache"
  $apache_cert = "${certs::pki_dir}/certs/katello-apache.crt"
  $apache_key  = "${certs::pki_dir}/private/katello-apache.key"

  if $::certs::server_cert {
    cert { $apache_cert_name:
      ensure          => present,
      hostname        => $hostname,
      generate        => $generate,
      deploy          => $deploy,
      regenerate      => $regenerate,
      custom_pubkey   => $::certs::server_cert,
      custom_privkey  => $::certs::server_key,
      custom_req      => $::certs::server_cert_req,
    }
  } else {
    cert { $apache_cert_name:
      ensure        => present,
      hostname      => $hostname,
      country       => $::certs::country,
      state         => $::certs::state,
      city          => $::certs::sity,
      org           => $::certs::org,
      org_unit      => $::certs::org_unit,
      expiration    => $::certs::expiration,
      ca            => $::certs::default_ca,
      generate      => $generate,
      regenerate    => $regenerate,
      deploy        => $deploy,
      password_file => $certs::ca_key_password_file,
    }
  }

  if $deploy {

    include ::apache

    Cert[$apache_cert_name] ~>
    pubkey { $apache_cert:
      ensure   => present,
      key_pair => Cert[$apache_cert_name],
      notify   => Service['httpd']
    } ~>
    privkey { $apache_key:
      ensure    => present,
      key_pair  => Cert[$apache_cert_name],
      notify    => Service['httpd']
    } ->
    file { $apache_key:
      owner => $::apache::user,
      group => $::apache::group,
      mode  => '0400',
    } ->
    Service['httpd']

  }
}
