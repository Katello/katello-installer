class qpid::config {

  user { 'qpidd':
    ensure => present,
    groups => [$::certs::user_groups],
  }

  file { "/etc/qpidd.conf":
    content => template("qpid/etc/qpidd.conf.erb")
  }

}
