# Definition: certs::tar_extract
#
# This class extracts a tarball
#
# Parameters:
# - The $path of the tarball to extract
#
# Actions:
# - Extracts a tarball
#
# Requires:
# - The certs class
#
define certs::tar_extract($path = $title) {
  exec { "extract ${path}":
    cwd     => '/root',
    path    => ['/usr/bin', '/bin'],
    command => "tar -xzf ${path}",
  }
}
