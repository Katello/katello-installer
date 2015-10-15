# Pulp Master Configuration
# Private class
class pulp::config {
  file { '/var/lib/pulp/packages':
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755',
  }

  file { '/etc/pulp/server.conf':
    ensure  => file,
    content => template('pulp/server.conf.erb'),
    owner   => 'apache',
    group   => 'apache',
    mode    => '0600',
  }

  file { '/etc/pki/pulp/content/pulp-global-repo.ca':
    ensure => link,
    target => $pulp::ca_cert,
  }

  if $pulp::enable_rpm {
    file { '/etc/pulp/repo_auth.conf':
      ensure  => file,
      content => template('pulp/repo_auth.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { '/etc/pulp/server/plugins.conf.d/yum_importer.json':
      ensure  => file,
      content => template('pulp/yum_importer.json'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { '/etc/pulp/server/plugins.conf.d/iso_importer.json':
      ensure  => file,
      content => template('pulp/iso_importer.json'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  if $pulp::enable_docker {
    file { '/etc/pulp/server/plugins.conf.d/docker_importer.json':
      ensure  => file,
      content => template('pulp/docker_importer.json'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  if $pulp::enable_puppet {
    exec { 'selinux_pulp_manage_puppet':
      command => 'semanage boolean -m --on pulp_manage_puppet',
      path    => '/sbin:/usr/sbin:/bin:/usr/bin',
      onlyif  => 'getsebool pulp_manage_puppet | grep off',
    }

    file { '/etc/pulp/server/plugins.conf.d/puppet_importer.json':
      ensure  => file,
      content => template('pulp/puppet_importer.json'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  file { '/etc/default/pulp_workers':
    ensure  => file,
    content => template("pulp/${pulp::pulp_workers_template}"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $pulp::reset_cache {
    exec { 'reset_pulp_cache':
      command => 'rm -rf /var/lib/pulp/packages/*',
      path    => '/sbin:/bin:/usr/bin',
      before  => Exec['migrate_pulp_db'],
      require => File['/var/lib/pulp/packages'],
    }
  }

  if $pulp::consumers_crl {
    exec { 'setup-crl-symlink':
      command     => "/usr/bin/openssl x509 -in '${pulp::ca_cert}' -hash -noout | /usr/bin/xargs -I{} /bin/ln -sf '${pulp::consumers_crl}' '/etc/pki/pulp/content/{}.r0'",
      logoutput   => 'on_failure',
      refreshonly => true,
    }
  }
}
