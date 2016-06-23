# Definition: certs::tar_create
#
# This class creates a tar ball of generated SSL certs
#
# Parameters:
# - The $path of files to tar up
# - The $capsule_fqdn
#
# Actions:
# - Create a tarball of SSL certs
#
# Requires:
# - The certs class
#
define certs::tar_create($path = $title, $capsule_fqdn = $::certs::capsule::capsule_fqdn) {
  exec { "generate ${path}":
    cwd     => '/root',
    path    => ['/usr/bin', '/bin'],
    command => "tar -czf ${path} ssl-build/*.noarch.rpm ssl-build/${capsule_fqdn}/*.noarch.rpm",
  }
}
