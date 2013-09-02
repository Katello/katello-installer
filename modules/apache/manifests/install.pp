class apache::install {
  case $::osfamily {
    RedHat: {
      $http_package = 'httpd'
    }
    Debian: {
      $http_package = 'apache2'
    }
    default: {
      fail("${::hostname}: This module does not support operatingsystem ${::osfamily}")
    }
  }

  package { $http_package:
    ensure => installed,
    alias  => 'httpd'
  }
}
