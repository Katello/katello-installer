# == Class: qpid::client
#
# Handles Qpid client package installations and configuration
#
class qpid::client {

  class { 'qpid::client::install': } ~>

  class { 'qpid::client::config': }

}
