class pulp::params {

  $oauth_key = 'pulp'
  $oauth_secret = 'secret'

  $messaging_url = 'tcp://localhost:5672'

  $consumers_ca_cert = '/etc/pki/tls/certs/localhost.crt'
  $consumers_ca_key = '/etc/pki/tls/private/localhost.key'

  $ssl_ca_cert = '/etc/pki/tls/certs/localhost.crt'

  $default_login = 'admin'
  $default_password = 'admin'

  $ssl_certificate_file     = "/etc/candlepin/certs/candlepin-ca.crt"
  $ssl_certificate_key_file = "/etc/candlepin/certs/candlepin-ca.key"
  $ssl_certificate_ca_file  = $ssl_certificate_file

  $repo_auth = true
}
