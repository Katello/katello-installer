# Pulp Master Params
# Private class
class pulp::params {
  $version = 'installed'

  $db_name = 'pulp_database'
  $db_seeds = 'localhost:27017'
  $db_username = undef
  $db_password = undef
  $db_replica_set = undef
  $db_ssl = false
  $db_ssl_keyfile = undef
  $db_ssl_certfile = undef
  $db_verify_ssl = true
  $db_ca_path = '/etc/pki/tls/certs/ca-bundle.crt'

  $server_name = downcase($::fqdn)
  $key_url = '/pulp/gpg'
  $ks_url = '/pulp/ks'
  $debugging_mode = false
  $log_level = 'INFO'

  $rsa_key = '/etc/pki/pulp/rsa.key'
  $rsa_pub = '/etc/pki/pulp/rsa_pub.key'

  $user_cert_expiration = 7
  $consumer_cert_expiration = 3650
  $serial_number_path = '/var/lib/pulp/sn.dat'

  $consumer_history_lifetime = 180
  $oauth_enabled = true
  $oauth_key = 'pulp'
  $oauth_secret = 'secret'

  $messaging_url = "tcp://${::fqdn}:5672"
  $messaging_transport = 'qpid'
  $messaging_auth_enabled = true
  $messaging_ca_cert = undef
  $messaging_client_cert = undef
  $messaging_topic_exchange = 'amq.topic'

  $broker_url = "qpid:///guest@${::fqdn}:5672"
  $broker_use_ssl = false

  $ca_cert = '/etc/pki/pulp/ca.crt'
  $ca_key = '/etc/pki/pulp/ca.key'
  $https_cert = $ca_cert
  $https_key = $ca_key
  $ssl_ca_cert = '/etc/pki/pulp/ssl_ca.crt'
  $enable_http = false
  $ssl_verify_client = 'require'

  $enable_rpm = true
  $enable_docker = false
  $enable_puppet = false
  $enable_python = false
  $enable_parent_node = false

  $email_host = 'localhost'
  $email_port = 25
  $email_from = "no-reply@${::domain}"
  $email_enabled = false

  $consumers_crl = undef

  $manage_db = true
  $manage_broker = true
  $manage_httpd = true
  $manage_plugins_httpd = true
  $reset_cache = false

  $default_login = 'admin'
  $default_password = cache_data('foreman_cache_data', 'pulp_password', random_password(32))

  $repo_auth = false

  $proxy_url = undef
  $proxy_port = undef
  $proxy_username = undef
  $proxy_password = undef

  $num_workers = min($::processorcount, 8)

  $node_certificate = '/etc/pki/pulp/nodes/node.crt'
  $node_verify_ssl = true
  $node_server_ca_cert = '/etc/pki/pulp/ca.crt'
  $node_oauth_effective_user = 'admin'
  $node_oauth_key = 'pulp'
  $node_oauth_secret = 'secret'

  $osreleasemajor = regsubst($::operatingsystemrelease, '^(\d+)\..*$', '\1')

  case $::osfamily {
    'RedHat' : {
      case $osreleasemajor {
        '6'     : { $pulp_workers_template = 'upstart_pulp_workers' }
        default : { $pulp_workers_template = 'systemd_pulp_workers' }
      }
    }
    default  : {
      fail("${::hostname}: This module does not support osfamily ${::operatingsystem}")
    }
  }
}
