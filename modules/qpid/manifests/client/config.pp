# == Class: qpid::client::configure
#
# Handles Qpid client configuration
#
class qpid::client::config {


  file { '/etc/qpid/qpidc.conf':
    ensure  => file,
    content => template('qpid/qpidc.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/qpidc.conf':
    ensure  => link,
    target  => '/etc/qpid/qpidc.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
