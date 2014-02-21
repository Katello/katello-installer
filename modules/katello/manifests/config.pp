# Katello Config
class katello::config {
  include katello::params

  group { $katello::group:
    ensure => 'present',
  } ~>
  user { $katello::user:
    ensure  => 'present',
    shell   => '/sbin/nologin',
    comment => 'Katello',
    gid     => $katello::group,
    groups  => $katello::user_groups,
  }

  # this should be required by all classes that need to log there (one of these)
  file { $katello::params::log_base:
    owner => $katello::params::user,
    group => $katello::params::group,
    mode  => '0750',
  }

  file { $katello::params::configure_log_base:
    owner => $katello::params::user,
    group => $katello::params::group,
    mode  => '0750',
  }

  file { '/usr/share/foreman/bundler.d/katello.rb':
    ensure  => file,
    owner   => $katello::params::user,
    group   => $katello::user_groups,
    mode    => '0644',
  }

  file { "${katello::params::config_dir}/katello.yml":
    ensure  => file,
    content => template("katello/${katello::params::config_dir}/katello.yml.erb"),
    owner   => $katello::params::user,
    group   => $katello::user_groups,
    mode    => '0644',
    before  => [Class['foreman::database'], Exec['foreman-rake-db:migrate']],
  }

  file { '/etc/sysconfig/katello':
    content => template('katello/etc/sysconfig/katello.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  foreman::config::passenger::fragment{ 'katello':
    content     => template('katello/etc/httpd/conf.d/05-foreman.d/katello.conf.erb'),
    ssl_content => template('katello/etc/httpd/conf.d/05-foreman-ssl.d/katello.conf.erb'),
  }

  file { '/etc/katello/client.conf':
    content => template('katello/etc/katello/client.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
