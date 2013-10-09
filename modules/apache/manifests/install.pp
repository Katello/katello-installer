class apache::install {
  case $::osfamily {
    RedHat: {
      $http_package = 'httpd'
    }
    Debian: {
      $http_package = 'apache2'
    }
    Linux: {
      case $::operatingsystem {
        Amazon: {
          $http_package = 'httpd'
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

  package { $http_package:
    ensure => installed,
    alias  => 'httpd'
  }
}
