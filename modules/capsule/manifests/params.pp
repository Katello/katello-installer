# Default params for capsule settings
class capsule::params {

  include foreman_proxy::params

  # when not specified, we expect all in one installation
  $parent_fqdn                = $::fqdn
  $certs_tar                  = undef

  # OAuth credentials
  # shares cached_data with the foreman module so they're the same
  $foreman_oauth_key          = cache_data('oauth_consumer_key', random_password(32))
  $foreman_oauth_secret       = cache_data('oauth_consumer_secret', random_password(32))

  $pulp                       = false
  $pulp_admin_password        = undef
  $pulp_oauth_effective_user  = 'admin'
  $pulp_oauth_key             = 'katello'
  $pulp_oauth_secret          = undef

  $puppet                        = false
  $puppetca                      = false

  $foreman_proxy_port            = '9090'
  $tftp                          = false
  $tftp_servername               = $foreman_proxy::params::tftp_servername
  $dhcp                          = false
  $dhcp_interface                = $foreman_proxy::params::dhcp_interface
  $dhcp_gateway                  = $foreman_proxy::params::dhcp_gateway
  $dhcp_range                    = $foreman_proxy::params::dhcp_range
  $dhcp_nameservers              = $foreman_proxy::params::dhcp_nameservers
  $dns                           = false
  $dns_zone                      = $foreman_proxy::params::dns_zone
  $dns_reverse                   = $foreman_proxy::params::dns_reverse
  $dns_interface                 = $foreman_proxy::params::dns_interface
  $dns_forwareders               = $foreman_proxy::params::dns_forwarders
  $foreman_oauth_effective_user  = $foreman_proxy::params::oauth_effective_user

}
