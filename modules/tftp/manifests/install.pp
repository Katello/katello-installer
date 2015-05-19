# Install TFTP
class tftp::install {
  package { $::tftp::params::package:
    ensure => installed,
    alias  => 'tftp-server',
  }

  package { $::tftp::params::syslinux_package:
    ensure => installed,
  }
}
