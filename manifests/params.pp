class apache::params {
  case $::osfamily {
    Debian: {
      $user      = 'www-data'
      $group     = 'www-data'
      $configdir = '/etc/apache2/conf.d'
      $conffile  = '/etc/apache2/apache2.conf'
    }
    default: {
      $user      = 'apache'
      $group     = 'apache'
      $configdir = '/etc/httpd/conf.d'
      $conffile  = '/etc/httpd/conf/httpd.conf'
    }
  }

  $home      = '/var/www'

}
