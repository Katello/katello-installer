# Katello Development Install
class katello_devel::install {

  include git

  package{ ['pulp-katello-plugins', 'libvirt-devel', 'sqlite-devel', 'postgresql-devel']:
    ensure => present
  }

  git::repo { 'katello':
    target => "${katello_devel::deployment_dir}/katello",
    source => 'https://github.com/Katello/katello.git',
    user   => $katello_devel::user,
  }

  git::repo { 'foreman':
    target => "${katello_devel::deployment_dir}/foreman",
    source => 'https://github.com/theforeman/foreman.git',
    user   => $katello_devel::user,
  }

}
