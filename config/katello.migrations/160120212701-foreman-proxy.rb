# Decouple puppet-foreman_proxy form puppet-capsule

def mod(manifest, params)
  {
    :manifest_name => manifest,
    :params_name => params,
    :dir_name => 'foreman_proxy'
  }
end

scenario[:log_level] = scenario[:log_level].to_s.upcase

scenario[:order] = [
  "certs",
  "foreman",
  "katello",
  "foreman_proxy",
  "foreman_proxy::plugin::pulp",
  "capsule"
]

scenario[:mapping]['foreman_proxy::plugin::discovery'] = mod('plugin/discovery', 'plugin/discovery/params')
scenario[:mapping]['foreman_proxy::plugin::abrt'] = mod('plugin/abrt', 'plugin/abrt/params')
scenario[:mapping]['foreman_proxy::plugin::chef'] = mod('plugin/chef', 'plugin/chef/params')
scenario[:mapping]['foreman_proxy::plugin::dns::powerdns'] = mod('plugin/dns/powerdns', 'plugin/dns/powerdns/params')
scenario[:mapping]['foreman_proxy::plugin::dynflow'] = mod('plugin/dynflow', 'plugin/dynflow/params')
scenario[:mapping]['foreman_proxy::plugin::openscap'] = mod('plugin/openscap', 'plugin/openscap/params')
scenario[:mapping]['foreman_proxy::plugin::pulp'] = mod('plugin/pulp', 'plugin/pulp/params')
scenario[:mapping]['foreman_proxy::plugin::remote_execution::ssh'] = mod('plugin/remote_execution/ssh', 'plugin/remote_execution/ssh/params')
scenario[:mapping]['foreman_proxy::plugin::salt'] = mod('plugin/salt', 'plugin/salt/params')

# foreman_proxy defaults
answers['foreman_proxy'] = {
  'custom_repo' => true,
  'http' => true,
  'ssl_port' => '9093',
  'templates' => false,
  'ssl_ca' => '/etc/foreman-proxy/ssl_ca.pem',
  'ssl_cert' => '/etc/foreman-proxy/ssl_cert.pem',
  'ssl_key' => '/etc/foreman-proxy/ssl_key.pem',
  'foreman_ssl_ca' => '/etc/foreman-proxy/foreman_ssl_ca.pem',
  'foreman_ssl_cert' => '/etc/foreman-proxy/foreman_ssl_cert.pem',
  'foreman_ssl_key' => '/etc/foreman-proxy/foreman_ssl_key.pem'
}

answers['foreman_proxy::plugin::pulp'] = {
  'enabled' => true,
  'pulpnode_enabled' => false
}

def move(name, default=nil, new_name=nil)
  return unless answers['capsule'].key?(name)
  answers['foreman_proxy'][(new_name || name)] = answers['capsule'].delete(name) { |k| default }
end

# migrate from capsule if exist
if answers['capsule'].is_a? Hash
  move('puppetca', true)
  move('tftp', true)
  move('tftp_syslinux_root')
  move('tftp_syslinux_files')
  move('tftp_root', '/var/lib/tftpboot')
  move('tftp_dirs', ['/var/lib/tftpboot/pxelinux.cfg', '/var/lib/tftpboot/boot'])
  move('tftp_servername')

  move('foreman_proxy_ssl_port', '9090', 'ssl_port')
  move('foreman_proxy_http', true, 'http')
  move('foreman_proxy_http_port', '8000', 'http_port')
end
