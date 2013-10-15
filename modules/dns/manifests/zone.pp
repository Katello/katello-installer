# Define new zone for the dns
define dns::zone (
    $zonetype='master',
    $soa='',
    $reverse=false,
    $ttl='10800',
    $soaip='',
    $refresh = 86400,
    $update_retry = 3600,
    $expire = 604800,
    $negttl = 3600,
    $zonefilepath     = $dns::params::zonefilepath,
    $namedservicename     = $dns::params::namedservicename
) {
  $contact = "root.${name}."
  $serial = 1

  if ! defined(Class[dns]) {
    class { 'dns':
      zonefilepath     => $zonefilepath,
      namedservicename => $namedservicename
    }
  }

  include dns::params

  $zone             = $name
  $filename         = "db.${zone}"
  $zonefilename     = "${zonefilepath}/${filename}"

  concat_fragment { "dns_zones+10_${zone}.dns":
    content => template('dns/named.zone.erb'),
  }

  file { $zonefilename:
    content => template('dns/zone.header.erb'),
    require => File[$zonefilepath],
    replace => false,
    notify  => Service[$namedservicename],
  }
}
