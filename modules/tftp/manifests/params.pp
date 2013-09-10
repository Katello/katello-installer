class tftp::params {
  case $::osfamily {
    Debian: {
      case $::operatingsystem {
        Debian: {
          $root    = '/srv/tftp'
          $daemon  = true
          $service = 'tftpd-hpa'
        }
        Ubuntu: {
          $root    = '/var/lib/tftpboot/'
          $daemon  = true
          $service = 'tftpd-hpa'
        }
      }
    }
    RedHat: {
      if $::operatingsystemrelease =~ /^(4|5)/ {
        $root  = '/tftpboot/'
      } else {
        $root  = '/var/lib/tftpboot/'
      }
      $daemon  = false
    }
    default: {
      fail("${::hostname}: This module does not support operatingsystem ${::osfamily}") }
  }
}
