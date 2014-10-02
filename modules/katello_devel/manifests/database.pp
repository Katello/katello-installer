# Database configuration
class katello_devel::database {

  $db_password = 'katello'
  $db_username = 'katello'

  $db_adapter = $katello_devel::db_type ? {
    'postgres' => 'postgresql',
    default    => 'sqlite3'
  }

  $db_name = $katello_devel::db_type ? {
    'sqlite' => 'db/katello.sqlite3',
    default  => 'katello'
  }

  file { "${katello_devel::deployment_dir}/foreman/config/database.yml":
    ensure  => file,
    content => template('katello_devel/database.yaml.erb'),
    owner   => $katello_devel::user,
    group   => $katello_devel::group,
    mode    => '0644',
  }

  if $katello_devel::db_type == 'postgres' {

    # Prevents errors if run from /root etc.
    Postgresql_psql {
      cwd => '/',
    }

    class { 'postgresql::server':
      encoding             => 'UTF8',
      pg_hba_conf_defaults => false,
    }

    postgresql::server::pg_hba_rule { 'local all':
      type        => 'local',
      database    => 'all',
      user        => 'all',
      auth_method => 'trust',
    }

    postgresql::server::pg_hba_rule { 'host IPV4':
      type        => 'host',
      database    => 'all',
      user        => 'all',
      address     => '127.0.0.1/32',
      auth_method => 'trust',
    }

    postgresql::server::pg_hba_rule { 'host IPV6':
      type        => 'host',
      database    => 'all',
      user        => 'all',
      address     => '::1/128',
      auth_method => 'trust',
    }

    postgresql::server::role { $db_username:
      password_hash => $db_password,
      superuser     => true
    }

    postgresql::server::role { 'candlepin':
      superuser => true
    }

    postgresql::server::db { $db_name:
      user     => $db_username,
      password => $db_password,
      owner    => $db_username,
    }

    Class['postgresql::server'] -> Postgresql::Server::Role[$db_username] -> Postgresql::Server::Database[$db_name]

  }

}
