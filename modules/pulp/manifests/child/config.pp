# Pulp Node Configuration
class pulp::child::config {

  file { '/etc/pulp/nodes.conf':
    ensure  => 'file',
    content => template('pulp/nodes.conf.erb'),
  }

  include ::apache

  apache::vhost { 'pulp-node-ssl':
    servername        => $::fqdn,
    docroot           => '/var/www/html',
    port              => 443,
    priority          => '25',
    ssl               => true,
    ssl_cert          => $pulp::child::ssl_cert,
    ssl_key           => $pulp::child::ssl_key,
    ssl_ca            => $pulp::ssl_ca_cert,
    ssl_verify_client => 'optional',
    ssl_options       => '+StdEnvVars',
    ssl_verify_depth  => '3',
  }

  # we need to make sure the goferd reads the current oauth credentials to talk
  # to the child node
  File['/etc/pulp/server.conf'] ~> Service['goferd']
}
