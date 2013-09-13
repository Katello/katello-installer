class xinetd::params {

  case $::osfamily {
    'Debian':  {
      $confdir       = '/etc/xinetd.d'
      $conffile      = '/etc/xinetd.conf'
      $package_name  = 'xinetd'
      $service_name  = 'xinetd'
    }
    'FreeBSD': {
      $confdir       = '/usr/local/etc/xinetd.d'
      $conffile      = '/usr/local/etc/xinetd.conf'
      $package_name  = 'security/xinetd'
      $service_name  = 'xinetd'
    }
    'Suse':  {
      $confdir       = '/etc/xinetd.d'
      $conffile      = '/etc/xinetd.conf'
      $package_name  = 'xinetd'
      $service_name  = 'xinetd'
    }
    'RedHat':  {
      $confdir       = '/etc/xinetd.d'
      $conffile      = '/etc/xinetd.conf'
      $package_name  = 'xinetd'
      $service_name  = 'xinetd'
    }
    default:   {
      fail("xinetd: module does not support osfamily ${::osfamily}")
    }
  }

}

