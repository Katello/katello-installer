class certs::params {
  $ca_common_name = $fqdn  # we need fqdn as CA common name as candlepin uses it as a ssl cert
  $country = 'US'
  $state   = 'North Carolina'
  $city    = 'Raleigh'
  $org     = 'SomeOrg'
  $org_unit = 'SomeOrgUnit'
  $expiration = '365'
  $ca_expiration = '36500'
}
