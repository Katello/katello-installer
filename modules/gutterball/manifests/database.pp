class gutterball::database{
  include postgresql::server

  postgresql::server::pg_hba_rule { 'allow authenticated users over ipv4 loopback':
    type        => 'host',
    database    => 'all',
    user        => 'all',
    address     => '127.0.0.1/32',
    auth_method => 'password',
  }

  postgresql::server::db { 'gutterball':
    user     => $gutterball::dbuser,
    password => $gutterball::dbpassword,
  } ~>
  file { '/usr/bin/gutterball-db':
    ensure  => file,
    content => template('gutterball/gutterball-db.erb'),
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  } ~>
  exec { 'migrate database':
      path        => ['/usr/bin', '/bin'],
      command     => 'gutterball-db migrate',
      refreshonly => true
  }


}
