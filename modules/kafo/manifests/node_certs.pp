# Prepare the certificates for the node from the parent node
#
# === Parameters:
#
# $parent_fqdn:: fqdn of the parent node. Usually not need to be set.
#
# $child_fqdn::  fqdn of the child node. REQUIRED
#
# $pulp::        should Pulp be configured on the node
#                type:boolean
#
class kafo::node_certs (
  $parent_fqdn = $fqdn,
  $child_fqdn  = $kafo::params::child_fqdn,
  $pulp        = $kafo::params::pulp
  ) inherits kafo::params {

  class {'::certs':
    node_fqdn => 'ibm-x3650-01.ovirt.rhts.eng.bos.redhat.com',
    generate => true,
    deploy   => false
  }

  if $pulp {
    class { 'apache::ssl': }
  }

  if $pulp {
    class { 'pulp::child::certs': }
    class { 'pulp::parent::certs':
      hostname => $parent_fqdn,
      deploy => true,
    }
  }
}
