# Setup and create gemset for RVM
class katello_devel::rvm {

  $rvm_install = 'install_rvm.sh'

  package{ ['curl', 'bash']:
    ensure => present
  }

  augeas { 'katello_devel-tty':
    context => '/files/etc/sudoers',
    changes => [
      "set Defaults[type = ':${katello_devel::user}']/type :${katello_devel::user}",
      "set Defaults[type = ':${katello_devel::user}']/requiretty/negate ''",
    ],
    require => User[$katello_devel::user],
  } ->
  augeas { 'katello_devel-sudo':
    context => '/files/etc/sudoers',
    changes => [
        "set spec[user = '${katello_devel::user}']/user '${katello_devel::user}'",
        "set spec[user = '${katello_devel::user}']/host_group/host ALL",
        "set spec[user = '${katello_devel::user}']/host_group/command ALL",
        "set spec[user = '${katello_devel::user}']/host_group/command/runas_user ALL",
        "set spec[user = '${katello_devel::user}']/host_group/command/tag NOPASSWD",
    ],
    require => User[$katello_devel::user],
  } ->
  file { "/usr/bin/${rvm_install}":
    content => template("katello_devel/${rvm_install}.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0744'
  } ~>
  exec { $rvm_install:
    path    => '/usr/bin:/usr/sbin:/bin',
    creates => "/home/${katello_devel::user}/.rvm/bin/rvm",
    timeout => 900,
    require => [ Package['curl'], Package['bash'], User[$katello_devel::user] ],
  }

}
