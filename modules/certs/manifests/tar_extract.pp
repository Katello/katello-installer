define certs::tar_extract($path = $title) {
  exec { "extract $path":
    cwd => '/root',
    path => ['/usr/bin', '/bin'],
    command => "tar -xzf $path"
  }
}
