# Pulp Admin Configuration
class pulp::admin::config {
  file { '/etc/pulp/admin/admin.conf':
    ensure  => 'file',
    content => template('pulp/admin.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $pulp::admin::enable_puppet {
    file { '/etc/pulp/admin/conf.d/puppet.conf':
      ensure  => 'file',
      content => template('pulp/admin_puppet.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }
}
