# Install TFTP
class tftp::install {
  package { $tftp::params::package:
    ensure => installed,
    alias  => 'tftp-server'
  }

  package {'syslinux':
    ensure => installed
  }
}
