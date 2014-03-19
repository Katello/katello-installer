# Handles certs for Capsules
class capsule::certs {

  certs::tar_extract { $capsule::certs_tar:
    before => Class['certs']
  }

}
