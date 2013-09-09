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
# $certs_tar::   path to tar file with certs to generate
#
class kafo::node_certs (
  $parent_fqdn = $fqdn,
  $child_fqdn  = $kafo::params::child_fqdn,
  $pulp        = $kafo::params::pulp,
  $certs_tar   = $kafo::params::child_fqdn
  ) inherits kafo::params {

  validate_present($child_fqdn)
  validate_present($certs_tar)
  validate_pulp($pulp)

  class {'::certs':
    node_fqdn => $child_fqdn,
    generate => true,
    deploy   => false
  }


  if $pulp {
    class { 'apache::ssl': notify => Certs::Tar_create[$certs_tar] }
    class { 'pulp::child::certs': notify => Certs::Tar_create[$certs_tar] }
    class { 'pulp::parent::certs':
      hostname => $parent_fqdn,
      deploy => true,
    }
  }

  certs::tar_create { $certs_tar: }

}
