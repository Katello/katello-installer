# foreman_gutterball plugin
class katello_devel::plugin::foreman_gutterball {
  $path = "${katello_devel::deployment_dir}/foreman-gutterball"
  $foreman_settings_path = "${katello_devel::deployment_dir}/foreman/config/settings.plugins.d"

  vcsrepo { $path:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/Katello/foreman-gutterball.git',
    user     => $katello_devel::user
  } ~>
  class { 'katello::plugin::gutterball::config':
    foreman_plugins_dir => $foreman_settings_path,
    foreman_user        => $katello_devel::user,
    foreman_group       => $katello_devel::group,
    require             => File[$foreman_settings_path],
  }

  Class[ 'katello_devel::install' ] ->
  file { "${katello_devel::deployment_dir}/foreman/bundler.d/foreman_gutterball.local.rb":
    ensure  => file,
    content => template('katello_devel/foreman_gutterball.local.rb.erb'),
    owner   => $katello_devel::user,
    group   => $katello_devel::group,
    mode    => '0644',
  }
}
