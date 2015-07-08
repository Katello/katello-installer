# Pulp Node Configuration
class pulp::child::config {

  file { '/etc/pulp/nodes.conf':
    ensure  => 'file',
    content => template('pulp/etc/pulp/nodes.conf.erb'),
  }

  include apache

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
    custom_fragment   => template('pulp/etc/httpd/conf.d/_pulp_node_ssl_include.erb'),
  }

  file { "${apache::confd_dir}/25-pulp-node-ssl.d":
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    purge   => true,
    recurse => true,
  }

  # we need to make sure the goferd reads the current oauth credentials to talk
  # to the child node
  File['/etc/pulp/server.conf'] ~> Service['goferd']
}
