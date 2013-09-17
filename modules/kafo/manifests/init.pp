# Configure the node
#
# === Parameters:
#
# $parent_fqdn::            fqdn of the parent node. REQUIRED
#
# $certs_tar::              path to a tar with certs for the node
#
# $pulp::                   should Pulp be configured on the node
#                           type:boolean
#
# $pulp_admin_password::    passowrd for the Pulp admin user.It should be left blank so that random password is generated
#                           type:password
#
# $foreman_proxy_port::     Port on which will foreman proxy listen
#                           type:integer
#
# $puppet::                 Use puppet
#                           type:boolean
#
# $puppetca::               Use puppet ca
#                           type:boolean
#
# $tftp::                   Use TFTP
#                           type:boolean
#
# $dhcp::                   Use DHCP
#                           type:boolean
#
# $dhcp_interface::         DHCP listen interface
#
# $dhcp_gateway::           DHCP pool gateway
#
# $dhcp_range::             Space-separated DHCP pool range
#
# $dhcp_nameservers::       DHCP nameservers
#
# $dns::                    Use DNS
#                           type:boolean
#
# $dns_interface::          DNS interface
#
# $dns_forwarders::         DNS forwarders
#                           type:array
#
# $register_in_foreman::    Register proxy back in Foreman
#                           type:boolean
#
# $oauth_effective_user::   User to be used for REST interaction
#
# $oauth_consumer_key::     OAuth key to be used for REST interaction
#
# $oauth_consumer_secret::  OAuth secret to be used for REST interaction
#
#
class kafo (
  $parent_fqdn           = $kafo::params::parent_fqdn,
  $certs_tar             = $kafo::params::certs_tar,
  $pulp                  = $kafo::params::pulp,
  $pulp_admin_password   = $kafo::params::pulp_admin_password,

  $foreman_proxy_port    = $kafo::params::foreman_proxy_port,

  $puppet                = $kafo::params::puppet,
  $puppetca              = $kafo::params::puppetca,

  $tftp                  = $kafo::params::tftp,

  $dhcp                  = $kafo::params::dhcp,
  $dhcp_interface        = $kafo::params::dhcp_interface,
  $dhcp_gateway          = $kafo::params::dhcp_gateway,
  $dhcp_range            = $kafo::params::dhcp_range,
  $dhcp_nameservers      = $kafo::params::dhcp_nameservers,

  $dns                   = $kafo::params::dns,
  $dns_interface         = $kafo::params::dns_interface,
  $dns_forwarders        = $kafo::params::dns_forwarders,

  $register_in_foreman   = $kafo::params::register_in_foreman,
  $oauth_effective_user  = $kafo::params::oauth_effective_user,
  $oauth_consumer_key    = $kafo::params::oauth_consumer_key,
  $oauth_consumer_secret = $kafo::params::oauth_consumer_secret
  ) inherits kafo::params {

  validate_present($parent_fqdn)

  if $pulp {
    validate_pulp($pulp)
  }

  $foreman_url = "https://$parent_fqdn/foreman"

  if $certs_tar {
    certs::tar_extract { $certs_tar:
      before => Class['certs']
    }
  }

  if $register_in_foreman {
    validate_present($oauth_consumer_secret)
  }

  if $parent_fqdn == $fqdn {
    # we are installing node features on the master
    $certs_generate = true
  } else {
    $certs_generate = false
  }

  class { 'certs': generate => $certs_generate, deploy   => true }

  if $pulp {
    class { 'apache::certs': }
    class { 'pulp':
      default_password => $pulp_admin_password
    }
    class { 'pulp::child':
      parent_fqdn => $parent_fqdn
    }
    katello_node { "https://${parent_fqdn}/katello":
      content => $pulp
    }
  }

  if $puppet {
    class { 'kafo::puppet_certs':
      client_cert => $kafo::params::puppet_client_cert,
      client_key  => $kafo::params::puppet_client_key,
      client_ca   => $kafo::params::puppet_client_ca,
    } ~>

    class { puppet:
      server                      => true,
      server_foreman_url          => $foreman_url,
      server_foreman_ssl_cert     => $kafo::params::puppet_client_cert,
      server_foreman_ssl_key      => $kafo::params::puppet_client_key,
      server_foreman_ssl_ca       => $kafo::params::puppet_client_ca,
      server_storeconfigs_backend => false,
      server_git_repo             => true, # for seeting up the /modules/$envifronment modulepath
      server_config_version       => ''
    }
  }


  if $tftp or $dhcp or $dns or $puppet or $puppetca {

    if $certs_generate {
      # we make sure the certs for foreman are properly deployed
      class { 'kafo::foreman_certs':
        hostname => $parent_fqdn,
        deploy   => true,
        before     => Service['foreman-proxy'],
      }
    }

    class { 'kafo::foreman_proxy_certs':
      proxy_cert => $kafo::params::foreman_proxy_cert,
      proxy_key  => $kafo::params::foreman_proxy_key,
      proxy_ca   => $kafo::params::foreman_proxy_ca,
      require    => Package['foreman-proxy'],
      before     => Service['foreman-proxy'],
    }

    class { foreman_proxy:
     custom_repo           => true,
     port                  => $foreman_proxy_port,
     puppetca              => $puppetca,
     ssl_cert              => $kafo::params::foreman_proxy_cert,
     ssl_key               => $kafo::params::foreman_proxy_key,
     ssl_ca                => $kafo::params::foreman_proxy_ca,
     tftp                  => $tftp,
     dhcp                  => $dhcp,
     dhcp_interface        => $dhcp_interface,
     dhcp_gateway          => $dhcp_gateway,
     dhcp_range            => $dhcp_range,
     dhcp_nameservers      => $dhcp_nameservers,
     dns                   => $dns,
     dns_interface         => $dns_interface,
     dns_forwarders        => $dns_forwarders,
     register_in_foreman   => $register_in_foreman,
     foreman_base_url      => $foreman_url,
     registered_proxy_url  => "https://${fqdn}:${foreman_proxy_port}",
     oauth_effective_user  => $oauth_effective_user,
     oauth_consumer_key    => $oauth_consumer_key,
     oauth_consumer_secret => $oauth_consumer_secret
    }
  }
}
