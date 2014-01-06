# Install, configure and start dns service
class dns(
  $namedconf_path = $dns::params::namedconf_path,
  $dnsdir = $dns::params::dnsdir,
  $dns_server_package = $dns::params::dns_server_package,
  $rndckeypath = $dns::params::rndckeypath,
  $rndc_alg = $dns::params::rndc_alg,
  $rndc_secret = $dns::params::rndc_secret,
  $optionspath = $dns::params::optionspath,
  $publicviewpath = $dns::params::publicviewpath,
  $vardir = $dns::params::vardir,
  $namedservicename = $dns::params::namedservicename,
  $zonefilepath = $dns::params::zonefilepath,
  $localzonepath = $dns::params::localzonepath,
  $forwarders = $dns::params::forwarders,
  $listen_on_v6 = $dns::params::listen_on_v6
) inherits dns::params {
  class { 'dns::install': } ~>
  class { 'dns::config': } ~>
  class { 'dns::service': } ->
  Class['dns']
}
