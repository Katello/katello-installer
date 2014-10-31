# Setup and create gemset for RVM
class katello_devel::rvm {

  $install_gpg_command = "su -c 'gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3' - ${katello_devel::user}"
  $install_command = "su -c 'curl -L https://get.rvm.io | bash -s stable' - ${katello_devel::user}"

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
  exec { $install_gpg_command:
    path    => '/usr/bin:/usr/sbin:/bin',
    timeout => 900,
    require => [ Package['curl'], Package['bash'], User[$katello_devel::user] ],
  } ->
  exec { $install_command:
    path    => '/usr/bin:/usr/sbin:/bin',
    creates => "/home/${katello_devel::user}/.rvm/bin/rvm",
    timeout => 900,
    require => [ Package['curl'], Package['bash'], User[$katello_devel::user] ],
  } ->
  exec { 'install 1.9.3':
    path    => '/usr/bin:/usr/sbin:/bin',
    timeout => 900,
    command => "su -c 'rvm install 1.9.3-p448' - ${katello_devel::user}"
  }

}
