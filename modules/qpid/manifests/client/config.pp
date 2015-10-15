# == Class: qpid::client::configure
#
# Handles Qpid client configuration
#
class qpid::client::config {
  file { $qpid::client::config_file:
    ensure  => file,
    content => template('qpid/qpidc.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}
