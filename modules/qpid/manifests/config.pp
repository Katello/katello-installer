class qpid::config {

  file { "/etc/qpidd.conf":
    content => template("qpid/etc/qpidd.conf.erb")
  }

}
