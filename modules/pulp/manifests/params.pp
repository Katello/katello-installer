# Pulp Master Params
class pulp::params {

  $oauth_key = 'pulp'
  $oauth_secret = 'secret'

  $messaging_url = 'tcp://localhost:5672'
  $messaging_ca_cert = undef
  $messaging_client_cert = undef

  $broker_url = "qpid://${::fqdn}:5671"
  $broker_use_ssl = true

  $consumers_ca_cert = '/etc/pki/pulp/ca.crt'
  $consumers_ca_key = '/etc/pki/pulp/ca.key'
  $ssl_ca_cert = '/etc/pki/pulp/ssl_ca.crt'

  $consumers_crl = undef

  $qpid_ssl = true
  $qpid_ssl_cert_db = '/etc/pki/example/nssdb'
  $qpid_ssl_cert_password_file = '/etc/pki/example/nssdb/nss_db_password-file'

  $default_login = 'admin'
  $default_password = cache_data('pulp_password', random_password(32))

  $repo_auth = true

  $user_groups = []

  $proxy_url      = undef
  $proxy_port     = undef
  $proxy_username = undef
  $proxy_password = undef
}
