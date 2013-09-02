# Configure the node
#
# === Parameters:
#
# $parent_fqdn:: fqdn of the parent node. REQUIRED
#
# $pulp::        should Pulp be configured on the node
#                type:boolean
#
# $certs_tar::   path to a tar with certs for the node
#
class kafo (
  $parent_fqdn = $kafo::params::parent_fqdn,
  $pulp        = $kafo::params::pulp,
  $certs_tar   = $kafo::params::child_fqdn
  ) inherits kafo::params {

  if $certs_tar {
    Certs::Tar_extract { $certs_tar:
      before => Class['certs']
  }

  class { 'certs': generate => false, deploy   => true }

  if $pulp {
    class { 'apache::ssl': }
    class { 'pulp': }
    class { 'pulp::child':
      parent_fqdn => $parent_fqdn,
    }
  }
}
