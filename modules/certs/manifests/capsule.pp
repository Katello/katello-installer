# Prepare the certificates for the node from the parent node
#
# === Parameters:
#
# $parent_fqdn::             fqdn of the parent node. Does not usually
#                            need to be set.
#
# $capsule_fqdn::            fqdn of the capsule. REQUIRED
#
# $certs_tar::               path to tar file with certs to generate. REQUIRED
#
class certs::capsule (
  $parent_fqdn                  = $fqdn,
  $capsule_fqdn                 = $certs::node_fqdn,
  $certs_tar                    = $certs::params::certs_tar
  ) inherits certs::params {

  # until we support again pushing the cert rpms to the Katello,
  # make sure the certs_tar path is present
  validate_present($certs_tar)
  validate_present($capsule_fqdn)

  class { 'certs::puppet':        hostname => $capsule_fqdn  }
  class { 'certs::foreman':       hostname => $capsule_fqdn }
  class { 'certs::foreman_proxy': hostname => $capsule_fqdn }
  class { 'certs::apache':        hostname => $capsule_fqdn }
  class { 'certs::qpid':          hostname => $capsule_fqdn }
  class { 'certs::qpid_router':   hostname => $capsule_fqdn }
  class { 'certs::pulp_child':    hostname => $capsule_fqdn }

  if $certs_tar {
    certs::tar_create { $certs_tar:
      subscribe => [Class['certs::puppet'],
                    Class['certs::foreman'],
                    Class['certs::foreman_proxy'],
                    Class['certs::qpid'],
                    Class['certs::qpid_router'],
                    Class['certs::apache'],
                    Class['certs::pulp_child']]
    }
  }
}
