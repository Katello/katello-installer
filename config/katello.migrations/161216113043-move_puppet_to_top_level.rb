answers['foreman_proxy_content'].delete('puppet')

answers['puppet'] ||= {
  'server' => true,
  'server_environments_owner' => 'apache',
  'server_foreman_ssl_cert' => '/etc/pki/katello/certs/puppet_client.crt',
  'server_foreman_ssl_key' => '/etc/pki/katello/private/puppet_client.key',
  'server_foreman_ssl_ca' => '/etc/pki/katello/certs/puppet_client_ca.crt'
}

scenario[:order] = [
  'certs',
  'foreman',
  'katello',
  'foreman_proxy',
  'foreman_proxy::plugin::pulp',
  'foreman_proxy_content',
  'puppet'
]
