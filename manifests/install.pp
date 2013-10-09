class passenger::install {
  case $::osfamily {
    RedHat: {
      $package_name = 'mod_passenger'
    }
    Debian: {
      $package_name = 'libapache2-mod-passenger'

      # Enable RequestHeaders
      exec { 'enable-headers':
        command => '/usr/sbin/a2enmod headers',
        creates => '/etc/apache2/mods-enabled/headers.load',
        require => Class['apache::install'],
        notify  => Class['apache::service'],
      }
    }
    Linux: {
      case $::operatingsystem {
        Amazon: {
          $package_name = 'mod_passenger'
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

  package { 'passenger':
    ensure  => installed,
    name    => $package_name,
    require => Class['apache::install'],
    before  => Class['apache::service'],
  }
}
