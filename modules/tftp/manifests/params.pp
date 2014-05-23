# TFTP defaults
class tftp::params {
  case $::osfamily {
    Debian: {
      $package = 'tftpd-hpa'
      $daemon  = true
      $service = 'tftpd-hpa'
      if $::operatingsystem == 'Ubuntu' {
        $root = '/var/lib/tftpboot/'
      } else {
        $root = '/srv/tftp'
      }
    }
    RedHat: {
      $package = 'tftp-server'
      $daemon  = false
      if $::operatingsystemrelease =~ /^(4|5)/ {
        $root  = '/tftpboot/'
      } else {
        $root  = '/var/lib/tftpboot/'
      }
    }
    Linux: {
      case $::operatingsystem {
        Amazon: {
          $package = 'tftp-server'
          $daemon  = false
          $root    = '/var/lib/tftpboot/'
        }
        default: {
          fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }
}
