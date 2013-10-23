class apache::ssl {
  include apache

  case $::osfamily {
    Debian: {
      exec { 'enable-ssl':
        command => '/usr/sbin/a2enmod ssl',
        creates => '/etc/apache2/mods-enabled/ssl.load',
        notify => Service['httpd'],
        require => Class['apache::install'],
      }
    }
    default: {
      package { 'mod_ssl':
        ensure => present,
        require => Package['httpd'],
        notify => Class['apache::service'],
      }
      file {['/var/cache/mod_ssl', '/var/cache/mod_ssl/scache']:
          ensure => directory,
          owner => 'apache',
          group => 'root',
          mode => '0700',
          notify => Exec['reload-apache'];
      }
    }
  }
}
