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
    validate_file_exists($certs_tar)
  }

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
    katello_node { "https://${parent_fqdn}/katello":
      content => $pulp
    }
  }

  if $tftp or $dhcp or $dns {
    class { foreman_proxy:
     custom_repo           => true,
     port                  => $foreman_proxy_port,
     puppetca              => false,
     ssl_ca                => false,
     ssl_cert              => false,
     ssl_key               => false,
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
     foreman_base_url      => "https://$parent_fqdn/foreman",
     registered_proxy_url  => "http://${fqdn}:${foreman_proxy_port}",
     oauth_effective_user  => $oauth_effective_user,
     oauth_consumer_key    => $oauth_consumer_key,
     oauth_consumer_secret => $oauth_consumer_secret
    }
  }
}
