# Set up the pulp database
class pulp::database {
  if $pulp::manage_db {
    if (versioncmp($::mongodb_version, '2.6.5') >= 0) {
      $mongodb_pidfilepath = '/var/run/mongodb/mongod.pid'
    } else {
      $mongodb_pidfilepath = '/var/run/mongodb/mongodb.pid'
    }

    # puppetlabs-mongodb is totally broken with managing users on < 2.6
    if (versioncmp($::mongodb_version, '2.6.0') >= 0) {
      $auth_real = $::pulp::db_username != undef and $::pulp::db_password != undef
    } else {
      $auth_real = false
    }

    class { '::mongodb::server':
      pidfilepath => $mongodb_pidfilepath,
      auth        => $auth_real,
      noauth      => !$auth_real,
    }

    if $auth_real {
      mongodb_user { $::pulp::db_username:
        ensure        => present,
        username      => $::pulp::db_username,
        password_hash => mongodb_password($::pulp::db_username, $::pulp::db_password),
        database      => $::pulp::db_name,
        roles         => ['dbAdmin', 'readWrite'],
        tries         => 10,
        require       => Service['mongodb'],
      }
    }

    Service['mongodb'] -> Service['pulp_celerybeat']
    Service['mongodb'] -> Service['pulp_workers']
    Service['mongodb'] -> Service['pulp_resource_manager']
    Service['mongodb'] -> Exec['migrate_pulp_db']
  }

  exec { 'migrate_pulp_db':
    command     => 'pulp-manage-db',
    path        => '/bin:/usr/bin',
    logoutput   => 'on_failure',
    user        => 'apache',
    refreshonly => true,
    require     => File['/etc/pulp/server.conf'],
  }

  Class['pulp::install'] ~> Exec['migrate_pulp_db'] ~> Class['pulp::service']
  Class['pulp::config'] ~> Exec['migrate_pulp_db'] ~> Class['pulp::service']
}
