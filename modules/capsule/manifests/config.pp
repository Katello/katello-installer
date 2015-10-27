# Capsule Config
class capsule::config {

  if $capsule::pulp {
    file {'/etc/httpd/conf.d/pulp.conf':
      ensure  => file,
      content => template('capsule/pulp.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file {'/etc/httpd/conf.d/pulp_nodes.conf':
      ensure  => file,
      content => template('capsule/pulp_nodes.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }
}
