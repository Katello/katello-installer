# Default parameters
class dns::params {
    case $::osfamily {
      'Debian': {
        $dnsdir             = '/etc/bind'
        $vardir             = '/var/cache/bind'
        $optionspath        = "${dnsdir}/named.conf.options"
        $zonefilepath       = "${vardir}/zones"
        $localzonepath      = "${dnsdir}/zones.rfc1918"
        $dns_server_package = 'bind9'
        $namedservicename   = 'bind9'
        $user               = 'bind'
        $group              = 'bind'
      }
      'RedHat': {
        $dnsdir             = '/etc'
        $vardir             = '/var/named'
        $optionspath        = '/etc/named/options.conf'
        $zonefilepath       = "${vardir}/dynamic"
        $localzonepath      = "${dnsdir}/named.rfc1912.zones"
        $dns_server_package = 'bind'
        $namedservicename   = 'named'
        $user               = 'named'
        $group              = 'named'
      }
      default: {
        fail ("Unsupported operating system family ${::osfamily}")
      }
    }

    $namedconf_path     = "${dnsdir}/named.conf"

    #pertaining to rndc
    $rndckeypath      = "${dnsdir}/rndc.key"

    #pertaining to views
    $publicviewpath   = "${dnsdir}/zones.conf"

    $forwarders       = []

    $listen_on_v6     = 'any'
}
