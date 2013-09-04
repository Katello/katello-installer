define certs::tar_create($path = $title, $child = $::certs::node_fqdn) {
  exec { "generate $path":
    cwd => '/root',
    path => ['/usr/bin', '/bin'],
    command => "tar -czf $path ssl-build/*.noarch.rpm ssl-build/$child/*.noarch.rpm",
  }
}
