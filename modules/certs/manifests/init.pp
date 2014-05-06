# == Class: certs
#
# Base for installing and configuring certs. It holds the basic configuration
# aournd certificates generation and deployment. The per-subsystem configuratoin
# of certificates should go into `subsystem_module/manifests/certs.pp`.
#
# === Parameters:
#
# $log_dir::              When the log files should go
#
# $node_fqdn::            The fqdn of the host the generated certificates
#                         should be for
#
# $generate::             Should the generation of the certs be part of the
#                         configuration
#                         type: boolean
#
# $regenerate::           Force regeneration of the certificates (excluding
#                         ca certificates)
#                         type: boolean
#
# $regenerate_ca::        Force regeneration of the ca certificate
#                         type: boolean
#
# $deploy::               Deploy the certs on the configured system. False means
#                         we want apply it on a different system
#                         type: boolean
#
# $ca_common_name::       Common name for the generated CA certificate
#                         type: string
#
# $country::              Country attribute for managed certificates
#                         type: string
#
# $state::                State attribute for managed certificates
#                         type: string
#
# $city::                 City attribute for managed certificates
#                         type: string
#
# $org::                  Org attribute for managed certificates
#                         type: string
#
# $org_unit::             Org unit attribute for managed certificates
#                         type: string
#
# $expiration::           Expiration attribute for managed certificates
#                         type: string
#
# $ca_expiration::        Ca expiration attribute for managed certificates
#                         type: string
#
# $pki_dir::              The PKI directory under which to place certs
#
# $ssl_build_dir::       The directory where SSL keys, certs and RPMs will be generated
#
# $user::                 The system user name who should own the certs;
#                         default 'foreman'
#
# $group::                The group who should own the certs;
#                         default 'foreman'
#
# $password_file_dir::    The location to store password files
#
# $default_ca_name::      The name of the default CA;
#                         default 'katello'
#
class certs (

  $log_dir        = $certs::params::log_dir,
  $node_fqdn      = $certs::params::node_fqdn,
  $generate       = $certs::params::generate,
  $regenerate     = $certs::params::regenerate,
  $regenerate_ca  = $certs::params::regenerate_ca,
  $deploy         = $certs::params::deploy,
  $ca_common_name = $certs::params::ca_common_name,
  $country        = $certs::params::country,
  $state          = $certs::params::state,
  $city           = $certs::params::city,
  $org            = $certs::params::org,
  $org_unit       = $certs::params::org_unit,

  $expiration     = $certs::params::expiration,
  $ca_expiration  = $certs::params::ca_expiration,

  $pki_dir = $certs::params::pki_dir,
  $ssl_build_dir = $certs::params::ssl_build_dir,

  $password_file_dir = $certs::params::password_file_dir,

  $user   = $certs::params::user,
  $group  = $certs::params::group,

  $default_ca_name = $certs::params::default_ca_name

  ) inherits certs::params {

  $nss_db_dir   = "${pki_dir}/nssdb"
  $default_ca   = Ca[$default_ca_name]

  $ca_key = "${certs::pki_dir}/private/${default_ca_name}.key"
  $ca_cert = "${certs::pki_dir}/certs/${default_ca_name}.crt"
  $ca_cert_stripped = "${certs::pki_dir}/certs/${default_ca_name}-stripped.crt"
  $ca_key_password = cache_data('ca_key_password', generate_password())
  $ca_key_password_file = "${certs::pki_dir}/private/${default_ca_name}.pwd"

  class { 'certs::install': } ->
  class { 'certs::config': } ->
  file { $ca_key_password_file:
    ensure  => file,
    content => $ca_key_password,
    owner   => 'root',
    group   => 'root',
    mode    => '0400'
  } ~>
  ca { $default_ca_name:
    ensure        => present,
    common_name   => $certs::ca_common_name,
    country       => $certs::country,
    state         => $certs::state,
    city          => $certs::city,
    org           => $certs::org,
    org_unit      => $certs::org_unit,
    expiration    => $certs::ca_expiration,
    generate      => $certs::generate,
    deploy        => $certs::deploy,
    password_file => $ca_key_password_file
  }

  if $deploy {

    Ca[$default_ca_name] ~>
    pubkey { $ca_cert:
      key_pair  => $default_ca
    } ~>
    pubkey { $ca_cert_stripped:
      strip     => true,
      key_pair  => $default_ca
    } ~>
    file { $ca_cert:
      ensure  => file,
      owner   => 'root',
      group   => $certs::group,
      mode    => '0644',
    }

    if $generate {
      Ca[$default_ca_name] ~>
      privkey { $ca_key:
        key_pair      => $default_ca,
        unprotect     => true,
        password_file => $ca_key_password_file
      } ~>
      file { $ca_key:
        ensure  => file,
        owner   => 'root',
        group   => $certs::group,
        mode    => '0440',
      }
    }
  }
}
