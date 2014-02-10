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
# $user::                 The system user name who should own the certs;
#                         default 'foreman'
#
# $group::                The group who should own the certs;
#                         default 'foreman'
#
# $password_file_dir::    The location to store password files
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

  $pki_dir = $::certs::params::candlepin_pki_dir,

  $password_file_dir = $certs::params::password_file_dir,

  $user   = $certs::params::user,
  $group  = $certs::params::group

  ) inherits certs::params {

  $nss_db_dir   = $certs::params::nss_db_dir
  $default_ca   = Ca['candlepin-ca']

  $candlepin_keystore_password_file = "${password_file_dir}/keystore_password-file"
  $candlepin_keystore_password = find_or_create_password($candlepin_keystore_password_file)

  $ssl_pk12_password_file = "${password_file_dir}/pk12_password-file"
  $nss_db_password_file   = "${password_file_dir}/nss_db_password-file"

  class { 'certs::install': } ->
  class { 'certs::config': } ->
  ca { 'candlepin-ca':
    ensure      => present,
    common_name => $certs::ca_common_name,
    country     => $certs::country,
    state       => $certs::state,
    city        => $certs::city,
    org         => $certs::org,
    org_unit    => $certs::org_unit,
    expiration  => $certs::ca_expiration,
    generate    => $certs::generate,
    regenerate  => $certs::regenerate_ca,
    deploy      => true,
  }

}
