class passenger::install::debian {

  package { 'passenger':
    ensure  => installed,
    name    => 'libapache2-mod-passenger',
    require => Class['apache::install'],
    before  => Class['apache::service'],
  }

  # Enable RequestHeaders
  exec { 'enable-headers':
    command => '/usr/sbin/a2enmod headers',
    creates => '/etc/apache2/mods-enabled/headers.load',
    require => Class['apache::install'],
    notify  => Class['apache::service'],
  }

}
