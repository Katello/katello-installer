class pulp::child::config {

  file {
    "/etc/pulp/nodes.conf":
     content => template("pulp/etc/pulp/nodes.conf.erb"),
  }

}
