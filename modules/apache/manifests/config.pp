class apache::config {

  group { $apache::params::group:
    ensure  => present,
    require => Class['apache::install']
  }
  user  { $apache::params::user:
    ensure     => present,
    home       => $apache::params::home,
    managehome => false,
    membership => 'minimum',
    groups     => [],
    shell      => '/sbin/nologin',
    require    => Group[$apache::params::group],
  }

  file { $apache::params::home:
    ensure => directory,
    owner  => $apache::params::user,
    group  => $apache::params::group
  }
  file { $apache::params::conffile:
    mode    => '0644',
    notify  => Exec['reload-apache'],
    require => Class['apache::install'],
  }
  file { $apache::params::configdir:
    ensure  => directory,
    mode    => '0644',
    notify  => Exec['reload-apache'],
    require => Class['apache::install'],
  }

  # Ensure the Version module is loaded as we need it in the Foreman vhosts
  # RedHat distros come with this enabled. Newer Debian and Ubuntu distros
  # comes also with this enabled. Only old Debian and Ubuntu distros (squeeze,
  # lucid, precise) needs hand-holding.
  case $::lsbdistcodename {
    'squeeze','lucid','precise': {
      exec { 'enable-version':
        command => '/usr/sbin/a2enmod version',
        creates => '/etc/apache2/mods-enabled/version.load',
        notify  => Service['httpd'],
        require => Class['apache::install'],
      }
    }
    default: {}
  }

}
