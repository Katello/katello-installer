# Prepare the certificates for the node from the parent node
#
# === Parameters:
#
# $parent_fqdn::             fqdn of the parent node. Usually not need to be set.
#
# $child_fqdn::              fqdn of the child node. REQUIRED
#
# $certs_tar::               path to tar file with certs to generate
#
# $regenerate::              regenerate certs for the node
#                            type:boolean
#
# $katello_user::            Katello username used for creating repo with certs.
#                            This param indicates that we want to distribute the certs via
#                            Katello repo
#
# $katello_password::        Katello password
#
# $katello_org::             Organization name to create a repository in
#
# $katello_repo_provider::   Provider name to create a repository in
#
# $katello_product::         Product name to create a repository in
#
# $katello_activation_key::  Activation key that registers the system
#                            with access to the cert repo (OPTIONAL)
#
class katello_installer::node_certs (
  $parent_fqdn            = $fqdn,
  $child_fqdn             = $katello_installer::params::child_fqdn,
  $certs_tar              = $katello_installer::params::child_fqdn,
  $regenerate             = $katello_installer::params::regenerate,
  $katello_user           = $katello_installer::params::katello_user,
  $katello_password       = $katello_installer::params::katello_password,
  $katello_org            = $katello_installer::params::katello_org,
  $katello_repo_provider  = $katello_installer::params::katello_repo_provider,
  $katello_product        = $katello_installer::params::katello_product,
  $katello_activation_key = $katello_installer::params::katello_activation_key
  ) inherits katello_installer::params {

  validate_present($child_fqdn)

  class {'::certs':
    node_fqdn  => $child_fqdn,
    generate   => true,
    regenerate => $regenerate,
    deploy     => false
  }


  class { 'certs::puppet': }
  class { 'certs::foreman_proxy': }
  class { 'certs::apache': }
  class { 'certs::pulp_child': }
  class { 'certs::pulp_parent':
    hostname => $parent_fqdn,
    deploy   => true,
  }
  class { 'certs::foreman':
    hostname => $parent_fqdn,
    deploy   => true,
  }

  if $certs_tar {
    certs::tar_create { $certs_tar:
      subscribe => [Class['certs::puppet'],
                    Class['certs::foreman'],
                    Class['certs::foreman_proxy'],
                    Class['certs::apache'],
                    Class['certs::pulp_child']]
    }
  }

  if $katello_user {

    katello_repo { $child_fqdn:
      user          => $katello_user,
      password      => $katello_password,
      org           => $katello_org,
      repo_provider => $katello_repo_provider,
      product       => $katello_product,
      package_files => ["/root/ssl-build/*.noarch.rpm", "/root/ssl-build/$child_fqdn/*.noarch.rpm"],
      subscribe     => [Class['certs::puppet'],
                        Class['certs::foreman'],
                        Class['certs::foreman_proxy'],
                        Class['certs::apache'],
                        Class['certs::pulp_child']],
    }

    if $katello_activation_key {
      katello_activation_key { $katello_activation_key:
        user     => $katello_user,
        password => $katello_password,
        org      => $katello_org,
        product  => $katello_product,
        require  => Katello_repo[$child_fqdn]
      }
    }

  }
}
