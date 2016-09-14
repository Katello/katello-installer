# Set up the pulp database
class pulp::database {
  if $pulp::manage_db {
    if (versioncmp($::mongodb_version, '2.6.5') >= 0) {
      $mongodb_pidfilepath = '/var/run/mongodb/mongod.pid'
    } else {
      $mongodb_pidfilepath = '/var/run/mongodb/mongodb.pid'
    }

    class { '::mongodb::server':
      pidfilepath => $mongodb_pidfilepath,
    }

    Service['mongodb'] -> Service['pulp_celerybeat']
    Service['mongodb'] -> Service['pulp_workers']
    Service['mongodb'] -> Service['pulp_resource_manager']
    Service['mongodb'] -> Service['pulp_streamer']
    Service['mongodb'] -> Exec['migrate_pulp_db']
  }

  exec { 'migrate_pulp_db':
    command   => 'pulp-manage-db && touch /var/lib/pulp/init.flag',
    path      => '/bin:/usr/bin',
    logoutput => 'on_failure',
    user      => 'apache',
    creates   => '/var/lib/pulp/init.flag',
    require   => File['/etc/pulp/server.conf'],
  }

  Class['pulp::install'] ~> Exec['migrate_pulp_db'] ~> Class['pulp::service']
  Class['pulp::config'] ~> Exec['migrate_pulp_db'] ~> Class['pulp::service']
}
