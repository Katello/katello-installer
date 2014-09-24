# Katello Config
class katello::config {

  file { '/usr/share/foreman/bundler.d/katello.rb':
    ensure => file,
    owner  => $katello::user,
    group  => $katello::group,
    mode   => '0644',
  }

  file { "${katello::config_dir}/katello.yaml":
    ensure  => file,
    content => template('katello/katello.yml.erb'),
    owner   => $katello::user,
    group   => $katello::group,
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

  file { "${katello::config_dir}/katello":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "${katello::config_dir}/katello/client.conf":
    ensure  => file,
    content => template('katello/client.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
