# Install dns service
class dns::install {
  package { 'dns':
    ensure => present,
    name   => $dns::dns_server_package,
  }
}
