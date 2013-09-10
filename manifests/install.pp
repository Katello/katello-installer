class tftp::install {
  case $::osfamily {
    RedHat: {
      $tftp_package = 'tftp-server'
    }
    Debian: {
      $tftp_package = 'tftpd-hpa'
    }
    default: {
      fail("${::hostname}: This module does not support operatingsystem ${::osfamily}")
    }
  }

  package { $tftp_package:
    ensure => installed,
    alias  => 'tftp-server'
  }

  package {'syslinux':
    ensure => installed
  }
}
