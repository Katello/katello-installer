# Prepare the certificates for the node from the parent node
#
# === Parameters:
#
# $parent_fqdn:: fqdn of the parent node. Usually not need to be set.
#
# $child_fqdn::  fqdn of the child node. REQUIRED
#
# $certs_tar::   path to tar file with certs to generate
#
# $pulp::        should Pulp be configured on the node
#                type:boolean
#
# $dns::         should DNS be configured on the node
#                type:boolean
#
# $dhcp::        should DHCP be configured on the node
#                type:boolean
#
# $tftp::        should TFTP be configured on the node
#                type:boolean
#
class kafo::node_certs (
  $parent_fqdn = $fqdn,
  $child_fqdn  = $kafo::params::child_fqdn,
  $certs_tar   = $kafo::params::child_fqdn,
  $pulp        = $kafo::params::pulp,
  $dns        = $kafo::params::dns,
  $dhcp        = $kafo::params::dhcp,
  $tftp        = $kafo::params::tftp
  ) inherits kafo::params {

  validate_present($child_fqdn)
  validate_present($certs_tar)

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
