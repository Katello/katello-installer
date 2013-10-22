class certs (
  $node_fqdn      = $fqdn,
  $generate       = true,
  $regenerate     = false,
  $regenerate_ca  = false,
  $deploy         = false,
  $ca_common_name    = $certs::params::ca_common_name,
  $country        = $certs::params::country,
  $state          = $certs::params::state,
  $city           = $certs::params::sity,
  $org            = $certs::params::org,
  $org_unit       = $certs::params::org_unit,

  $expiration     = $certs::params::expiration,
  $ca_expiration     = $certs::params::ca_expiration
  ) inherits params {

  $default_ca = Ca['candlepin-ca']

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
