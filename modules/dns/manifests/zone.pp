# Define new zone for the dns
define dns::zone (
    $zonetype       = 'master',
    $soa            = $::fqdn,
    $reverse        = false,
    $ttl            = '10800',
    $soaip          = $::ipaddress,
    $refresh        = 86400,
    $update_retry   = 3600,
    $expire         = 604800,
    $negttl         = 3600,
    $serial         = 1,
    $masters        = [],
    $allow_transfer = [],
    $also_notify    = [],
    $zone           = $title,
    $contact        = "root.${title}.",
    $zonefilepath   = $::dns::zonefilepath,
    $filename       = "db.${title}",
    $manage_file    = true,
    $forward        = 'first',
    $forwarders     = [],
) {

  validate_bool($reverse, $manage_file)
  validate_array($masters, $allow_transfer, $forwarders, $also_notify)
  validate_re($forward, '^(first|only)$', 'Only \'first\' or \'only\' are valid values for forward field')

  $zonefilename = "${zonefilepath}/${filename}"

  concat::fragment { "dns_zones+10_${zone}.dns":
    target  => $::dns::publicviewpath,
    content => template('dns/named.zone.erb'),
    order   => "10-${zone}",
  }

  if $manage_file {
    file { $zonefilename:
      ensure  => file,
      owner   => $dns::user,
      group   => $dns::group,
      mode    => '0644',
      content => template('dns/zone.header.erb'),
      replace => false,
      notify  => Service[$::dns::namedservicename],
    }
  }
}
