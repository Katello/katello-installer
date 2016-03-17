define pulp::apache_plugin ($confd = true, $vhosts80 = true) {
  if $confd {
    file { "/etc/httpd/conf.d/pulp_${name}.conf":
      ensure  => file,
      content => template("pulp/etc/httpd/conf.d/pulp_${name}.conf.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  if $vhosts80 {
    file { "/etc/pulp/vhosts80/${name}.conf":
      ensure  => file,
      content => template("pulp/vhosts80/${name}.conf"),
      owner   => 'apache',
      group   => 'apache',
      mode    => '0600',
    }
  }
}
