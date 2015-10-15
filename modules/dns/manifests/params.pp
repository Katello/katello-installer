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
        $rndcconfgen        = '/usr/sbin/rndc-confgen'
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
        $rndcconfgen        = '/usr/sbin/rndc-confgen'
      }
      /^(FreeBSD|DragonFly)$/: {
        $dnsdir             = '/usr/local/etc/namedb'
        $vardir             = '/usr/local/etc/namedb/working'
        $optionspath        = '/usr/local/etc/namedb/options.conf'
        $zonefilepath       = "${dnsdir}/dynamic"
        $localzonepath      = undef # "${dnsdir}/master/empty.db"
        $dns_server_package = 'bind910'
        $namedservicename   = 'named'
        $user               = 'bind'
        $group              = 'bind'
        $rndcconfgen        = '/usr/local/sbin/rndc-confgen'
      }
      default: {
        fail ("Unsupported operating system family ${::osfamily}")
      }
    }
    
    $namedconf_template   = 'dns/named.conf.erb'
    $optionsconf_template = 'dns/options.conf.erb'

    $namedconf_path       = "${dnsdir}/named.conf"

    #pertaining to rndc
    $rndckeypath          = "${dnsdir}/rndc.key"

    #pertaining to views
    $publicviewpath       = "${dnsdir}/zones.conf"

    $forwarders           = []

    $listen_on_v6         = 'any'

    $recursion            = 'yes'
    $allow_recursion      = []
    $allow_query          = [ 'any' ]

    $dnssec_enable        = 'yes'
    $dnssec_validation    = 'yes'
}
