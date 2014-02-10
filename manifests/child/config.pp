# Pulp Node Configuration
class pulp::child::config {

  file { '/etc/pulp/nodes.conf':
    ensure  => 'file',
    content => template('pulp/etc/pulp/nodes.conf.erb'),
  }

  # we need to make sure the goferd reads the current oauth credentials to talk
  # to the child node
  File['/etc/pulp/server.conf'] ~> Service['goferd']
}
