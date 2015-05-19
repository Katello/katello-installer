# Default params for capsule settings
class capsule::params {

  include foreman_proxy::params

  # when not specified, we expect all in one installation
  $parent_fqdn                = $::fqdn

  # OAuth credentials
  # shares cached_data with the foreman module so they're the same
  $foreman_oauth_key          = cache_data('oauth_consumer_key', random_password(32))
  $foreman_oauth_secret       = cache_data('oauth_consumer_secret', random_password(32))

  $pulp                       = false
  $pulp_master                = false
  $pulp_admin_password        = cache_data('pulp_node_admin_password', random_password(32))
  $pulp_oauth_effective_user  = 'admin'
  $pulp_oauth_key             = 'katello'
  $pulp_oauth_secret          = undef

  $reverse_proxy      = false
  $reverse_proxy_port = 8443

  $puppet                        = false
  $puppetca                      = false
  $puppet_ca_proxy               = ''

  $foreman_proxy_port            = '9090'

  $foreman_proxy_http            = true
  $foreman_proxy_http_port       = '8000'

  $tftp                          = false
  $tftp_servername               = $foreman_proxy::params::tftp_servername
  $tftp_syslinux_files           = $foreman_proxy::params::tftp_syslinux_files
  $tftp_syslinux_root            = $foreman_proxy::params::tftp_syslinux_root
  $tftp_root                     = $foreman_proxy::params::tftp_root
  $tftp_dirs                     = $foreman_proxy::params::tftp_dirs

  $bmc                           = false
  $bmc_default_provider          = 'ipmitool'

  $dhcp                          = false
  $dhcp_managed                  = $foreman_proxy::params::dhcp_managed
  $dhcp_interface                = $foreman_proxy::params::dhcp_interface
  $dhcp_gateway                  = $foreman_proxy::params::dhcp_gateway
  $dhcp_range                    = $foreman_proxy::params::dhcp_range
  $dhcp_nameservers              = $foreman_proxy::params::dhcp_nameservers
  $dhcp_vendor                   = $foreman_proxy::params::dhcp_vendor
  $dhcp_config                   = $foreman_proxy::params::dhcp_config
  $dhcp_leases                   = $foreman_proxy::params::dhcp_leases
  $dhcp_key_name                 = $foreman_proxy::params::dhcp_key_name
  $dhcp_key_secret               = $foreman_proxy::params::dhcp_key_secret

  $dns                           = false
  $dns_managed                   = $foreman_proxy::params::dns_managed
  $dns_provider                  = $foreman_proxy::params::dns_provider
  $dns_zone                      = $foreman_proxy::params::dns_zone
  $dns_reverse                   = $foreman_proxy::params::dns_reverse
  $dns_interface                 = $foreman_proxy::params::dns_interface
  $dns_server                    = $foreman_proxy::params::dns_server
  $dns_ttl                       = $foreman_proxy::params::dns_ttl
  $dns_tsig_keytab               = $foreman_proxy::params::dns_tsig_keytab
  $dns_tsig_principal            = $foreman_proxy::params::dns_tsig_principal
  $dns_forwarders                = $foreman_proxy::params::dns_forwarders
  $foreman_oauth_effective_user  = $foreman_proxy::params::oauth_effective_user

  $virsh_network                 = $foreman_proxy::params::virsh_network

  # Realm management options
  $realm                         = false
  $realm_provider                = $foreman_proxy::params::realm_provider
  $realm_keytab                  = $foreman_proxy::params::realm_keytab
  $realm_principal               = $foreman_proxy::params::realm_principal
  $freeipa_remove_dns            = $foreman_proxy::params::freeipa_remove_dns

  # Templates proxy
  $templates                     = false

  $register_in_foreman = false
  $certs_tar = undef

  $rhsm_url = '/rhsm'

  $qpid_router             = true
  $qpid_router_hub_addr    = '0.0.0.0'
  $qpid_router_agent_addr  = '0.0.0.0'
  $qpid_router_broker_addr = $::fqdn
  $qpid_router_hub_port    = 5646
  $qpid_router_agent_port  = 5647
  $qpid_router_broker_port = 5671
}
