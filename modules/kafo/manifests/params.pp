class kafo::params {

  include foreman_proxy::params

  $parent_fqdn                = undef
  $child_fqdn                 = undef
  $certs_tar                  = undef
  $regenerate                 = false
  $pulp                       = false
  $pulp_admin_password        = undef
  $pulp_oauth_effective_user  = 'admin'
  $pulp_oauth_key             = 'katello'
  $pulp_oauth_secret          = undef

  $puppet                = false
  $puppetca              = false

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
  $register_in_foreman           = false
  $foreman_oauth_effective_user  = $foreman_proxy::params::oauth_effective_user
  $foreman_oauth_key             = 'foreman'
  $foreman_oauth_secret          = undef

  $katello_user = undef
  $katello_password = undef
  $katello_org = 'Katello Infrastructure'
  $katello_repo_provider = 'node-installer'
  $katello_product = 'node-certs'
  $katello_activation_key = undef

  $foreman_client_cert = '/etc/foreman/client_cert.pem'
  $foreman_client_key = '/etc/foreman/client_key.pem'
  $foreman_client_ca = '/etc/foreman/client_ca.pem'

  $puppet_client_cert = '/etc/puppet/client_cert.pem'
  $puppet_client_key = '/etc/puppet/client_key.pem'
  $puppet_client_ca = '/etc/puppet/client_ca.pem'

  $foreman_proxy_cert = '/etc/foreman-proxy/ssl_cert.pem'
  $foreman_proxy_key = '/etc/foreman-proxy/ssl_key.pem'
  $foreman_proxy_ca = '/etc/foreman-proxy/ssl_ca.pem'
}
