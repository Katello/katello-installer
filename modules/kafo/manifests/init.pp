# Configure the node
#
# === Parameters:
#
# $parent_fqdn:: fqdn of the parent node. REQUIRED
#
# $pulp::        should Pulp be configured on the node
#                type:boolean
#
class kafo (
  $parent_fqdn = $kafo::params::parent_fqdn,
  $pulp        = $kafo::params::pulp
  ) inherits kafo::params {

  class { 'certs': generate => false, deploy   => true }

  if $pulp {
    class { 'apache::ssl': }
    class { 'pulp': }
    class { 'pulp::child':
      parent_fqdn => $parent_fqdn,
    }
  }
}
