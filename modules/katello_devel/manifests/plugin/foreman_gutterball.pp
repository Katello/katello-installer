# foreman_gutterball plugin
class katello_devel::plugin::foreman_gutterball {
  $path = "${katello_devel::deployment_dir}/foreman-gutterball"

  vcsrepo { $path:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/Katello/foreman-gutterball.git',
    user     => $katello_devel::user
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
