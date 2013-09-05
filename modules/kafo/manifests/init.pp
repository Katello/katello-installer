# Configure the node
#
# === Parameters:
#
# $parent_fqdn:: fqdn of the parent node. REQUIRED
#
# $pulp::        should Pulp be configured on the node
#                type:boolean
#
# $pulp_admin_password:: passowrd for the Pulp admin user.It should be left blank so that random password is generated
#                        type:password
#
# $certs_tar::   path to a tar with certs for the node
#
class kafo (
  $parent_fqdn         = $kafo::params::parent_fqdn,
  $pulp                = $kafo::params::pulp,
  $pulp_admin_password = $kafo::params::pulp_admin_password,
  $certs_tar           = $kafo::params::child_fqdn
  ) inherits kafo::params {

  validate_present($parent_fqdn)
  validate_file_exists($certs_tar)
  validate_pulp($pulp)

  if $certs_tar {
    certs::tar_extract { $certs_tar:
      before => Class['certs']
    }
  }

  class { 'certs': generate => false, deploy   => true }

  if $pulp {
    class { 'apache::ssl': }
    class { 'pulp':
      default_password => $pulp_admin_password
    }
    class { 'pulp::child':
      parent_fqdn => $parent_fqdn
    }
  }

  katello_node { "https://${parent_fqdn}/katello":
    content => $pulp
  }
}
