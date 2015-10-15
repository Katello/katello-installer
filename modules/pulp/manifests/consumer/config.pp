# Pulp Consumer Configuration
class pulp::consumer::config {
  file { '/etc/pulp/consumer/consumer.conf':
    ensure  => 'file',
    content => template('pulp/consumer.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $pulp::consumer::enable_rpm {
    file { '/etc/yum/pluginconf.d/pulp-profile-update.conf':
      ensure  => 'file',
      content => template('pulp/pulp-profile-update.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { '/etc/pulp/agent/conf.d/bind.conf':
      ensure  => 'file',
      content => template('pulp/agent_bind.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { '/etc/pulp/agent/conf.d/linux.conf':
      ensure  => 'file',
      content => template('pulp/agent_linux.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { '/etc/pulp/agent/conf.d/rpm.conf':
      ensure  => 'file',
      content => template('pulp/agent_rpm.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  if $pulp::consumer::enable_puppet {
    file { '/etc/pulp/agent/conf.d/puppet_bind.conf':
      ensure  => 'file',
      content => template('pulp/agent_puppet_bind.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { '/etc/pulp/agent/conf.d/puppet_module.conf':
      ensure  => 'file',
      content => template('pulp/agent_puppet_module.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }
}
