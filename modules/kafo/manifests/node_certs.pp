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
class kafo::node_certs (
  $parent_fqdn            = $fqdn,
  $child_fqdn             = $kafo::params::child_fqdn,
  $certs_tar              = $kafo::params::child_fqdn,
  $regenerate             = $kafo::params::regenerate,
  $katello_user           = $kafo::params::katello_user,
  $katello_password       = $kafo::params::katello_password,
  $katello_org            = $kafo::params::katello_org,
  $katello_repo_provider  = $kafo::params::katello_repo_provider,
  $katello_product        = $kafo::params::katello_product,
  $katello_activation_key = $kafo::params::katello_activation_key
  ) inherits kafo::params {

  validate_present($child_fqdn)

  class {'::certs':
    node_fqdn  => $child_fqdn,
    generate   => true,
    regenerate => $regenerate,
    deploy     => false
  }


  class { 'kafo::puppet_certs': }
  class { 'kafo::foreman_proxy_certs': }
  class { 'apache::certs': }
  class { 'pulp::child::certs': }
  class { 'pulp::parent::certs':
    hostname => $parent_fqdn,
    deploy   => true,
  }
  class { 'kafo::foreman_certs':
    hostname => $parent_fqdn,
    deploy   => true,
  }

  if $certs_tar {
    certs::tar_create { $certs_tar:
      subscribe => [Class['kafo::puppet_certs'],
                    Class['kafo::foreman_certs'],
                    Class['kafo::foreman_proxy_certs'],
                    Class['apache::certs'],
                    Class['pulp::child::certs']]
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
      subscribe     => [Class['kafo::puppet_certs'],
                        Class['kafo::foreman_certs'],
                        Class['kafo::foreman_proxy_certs'],
                        Class['apache::certs'],
                        Class['pulp::child::certs']],
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
