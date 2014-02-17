# Pulp Master Configuration
class pulp::config {

  file {'/var/lib/pulp/packages':
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755';
  }

  file {'/etc/pulp/server.conf':
    ensure  => file,
    content => template('pulp/etc/pulp/server.conf.erb'),
    owner   => 'apache',
    group   => 'apache',
    mode    => '0600',
  }

  file {'/etc/httpd/conf.d/pulp.conf':
    ensure  => file,
    content => template('pulp/etc/httpd/conf.d/pulp.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file {'/etc/httpd/conf.d/pulp_puppet.conf':
    ensure  => file,
    content => template('pulp/etc/httpd/conf.d/pulp_puppet.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file {'/etc/httpd/conf.d/pulp_rpm.conf':
    ensure  => file,
    content => template('pulp/etc/httpd/conf.d/pulp_rpm.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file {'/etc/httpd/conf.d/pulp_nodes.conf':
    ensure  => file,
    content => template('pulp/etc/httpd/conf.d/pulp_nodes.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file {'/etc/pulp/repo_auth.conf':
    ensure  => file,
    content => template('pulp/etc/pulp/repo_auth.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file {'/etc/pki/pulp/content/pulp-global-repo.ca':
      ensure => link,
      target => $pulp::consumers_ca_cert,
  }

  if $pulp::reset_cache {
    exec {'reset_pulp_cache':
      command => 'rm -rf /var/lib/pulp/packages/*',
      path    => '/sbin:/bin:/usr/bin',
      before  => Exec['migrate_pulp_db'],
      require => [
        File['/var/lib/pulp/packages'],
        ],
    }
  }

  if $pulp::reset_data {
    exec {'reset_pulp_db':
      command     => 'rm -f /var/lib/pulp/init.flag && service-wait httpd stop && service-wait mongod stop && rm -f /var/lib/mongodb/pulp_database*&& service-wait mongod start && rm -rf /var/lib/pulp/{distributions,published,repos}/*',
      path        => '/sbin:/usr/sbin:/bin:/usr/bin',
      before      => Exec['migrate_pulp_db'],
    }
  }

  exec {'migrate_pulp_db':
    command     => 'pulp-manage-db && touch /var/lib/pulp/init.flag',
    creates     => '/var/lib/pulp/init.flag',
    path        => '/bin:/usr/bin',
    logoutput   => 'on_failure',
    require     => File['/etc/pulp/server.conf'],
  }

  if $pulp::consumers_crl {
    exec { 'setup-crl-symlink':
      command     => "/usr/bin/openssl x509 -in '${pulp::consumers_ca_cert}' -hash -noout | /usr/bin/xargs -I{} /bin/ln -sf '${pulp::consumers_crl}' '/etc/pki/pulp/content/{}.r0'",
      logoutput   => 'on_failure'
    }
  }
}
