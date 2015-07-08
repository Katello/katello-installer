# provides the ability to specify fragments for the ssl 
#   virtual host defined for a pulp node
#
#  === Parameters:
#
#  $ssl_content:: content of the ssl virtual host fragment
#
define pulp::child::fragment(
  $ssl_content=undef,
) {

  require pulp::child::config

  $https_path = "${apache::confd_dir}/25-pulp-node-ssl.d/${name}.conf"

  if $ssl_content and $ssl_content != '' and $ssl_content != undef {
    file { $https_path:
      ensure  => file,
      content => $ssl_content,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  } else {
    file { $https_path:
      ensure => absent,
    }
  }

  File[$https_path] ~> Class['apache::service']
}
