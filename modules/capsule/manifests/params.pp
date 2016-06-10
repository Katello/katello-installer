# Default params for capsule settings
class capsule::params {

  # when not specified, we expect all in one installation
  $parent_fqdn        = $::fqdn

  $reverse_proxy      = false
  $reverse_proxy_port = 8443

  $puppet             = false
  $puppet_ca_proxy    = undef

  $certs_tar = undef
  $rhsm_url = '/rhsm'

  $pulp_master               = false
  $pulp_admin_password       = cache_data('foreman_cache_data', 'pulp_node_admin_password', random_password(32))
  $pulp_oauth_effective_user = 'admin'
  $pulp_oauth_key            = 'katello'
  $pulp_oauth_secret         = undef

  $qpid_router               = true
  $qpid_router_hub_addr      = '0.0.0.0'
  $qpid_router_agent_addr    = '0.0.0.0'
  $qpid_router_broker_addr   = $::fqdn
  $qpid_router_hub_port      = 5646
  $qpid_router_agent_port    = 5647
  $qpid_router_broker_port   = 5671
  $enable_ostree             = false
}
