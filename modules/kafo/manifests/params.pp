class kafo::params {

  include foreman_proxy::params

  $parent_fqdn           = undef
  $child_fqdn            = undef
  $certs_tar             = undef
  $pulp                  = true
  $pulp_admin_password   = undef

  $puppet                = true
  $puppetca              = true

  $foreman_proxy_port    = "9090"
  $dhcp                  = $foreman_proxy::params::dhcp
  $dhcp_interface        = $foreman_proxy::params::dhcp_interface
  $dhcp_gateway          = $foreman_proxy::params::dhcp_gateway
  $dhcp_range            = $foreman_proxy::params::dhcp_range
  $dhcp_nameservers      = $foreman_proxy::params::dhcp_nameservers
  $dns                   = $foreman_proxy::params::dns
  $dns_interface         = $foreman_proxy::params::dns_interface
  $dns_forwareders       = $foreman_proxy::params::dns_forwarders
  $register_in_foreman   = $foreman_proxy::params::register_in_foreman
  $oauth_effective_user  = $foreman_proxy::params::oauth_effective_user
  $oauth_consumer_key    = "foreman"
  $oauth_consumer_secret = undef

  $katello_user = undef
  $katello_password = undef
  $katello_org = "Katello Infrastructure"
  $katello_repo_provider = "node-installer"
  $katello_product = "node-certs"
  $katello_activation_key = undef
}
