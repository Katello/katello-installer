# Configure Crane
class crane::config {
  file { '/etc/crane.conf':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('crane/crane.conf.erb')
  }
}
