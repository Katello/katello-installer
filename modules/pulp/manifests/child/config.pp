class pulp::child::config {

  file {
    "/etc/pulp/consumer/consumer.conf":
      content => template("pulp/etc/pulp/consumer/consumer.conf.erb"),
  }

}
