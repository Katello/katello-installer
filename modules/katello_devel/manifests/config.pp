# Configuration for Katello development
class katello_devel::config {

  # Required until the katello.yml.erb changes to '@variable' syntax
  include ::katello::params

  file { "${katello_devel::deployment_dir}/katello/config/katello.yml":
    ensure  => file,
    content => template('katello/katello.yml.erb'),
    owner   => $katello_devel::user,
    group   => $katello_devel::group,
    mode    => '0644',
  }

  file { "${katello_devel::deployment_dir}/foreman/bundler.d/katello.local.rb":
    ensure => link,
    target => "${katello_devel::deployment_dir}/katello/doc/katello.local.rb",
    owner  => $katello_devel::user,
    group  => $katello_devel::group,
    mode   => '0644',
  }

  file { "${katello_devel::deployment_dir}/foreman/config/settings.yaml":
    ensure  => file,
    content => template('katello_devel/settings.yaml.erb'),
    owner   => $katello_devel::user,
    group   => $katello_devel::group,
    mode    => '0644',
  }

  file { "${katello_devel::deployment_dir}/foreman/config/settings.plugins.d":
    ensure => directory,
    owner  => $katello_devel::user,
    group  => $katello_devel::group,
    mode   => '0755',
  }

}
