class pulp (
  $oauth_key = $pulp::params::oauth_key,
  $oauth_secret = $pulp::params::oauth_secret,

  $messaging_url = $pulp::params::messaging_url,
  $messaging_cacert = undef,
  $messaging_clientcert = undef,

  $consumers_ca_cert = '/etc/pki/tls/certs/pulp_consumers_ca.crt',
  $consumers_ca_key = undef,
  $consumers_crl = undef,

  $ssl_ca_cert = '/etc/pki/tls/certs/pulp_ssl_cert.crt',

  $default_login = $pulp::params::default_login,
  $default_password = $pulp::params::default_password,

  $repo_auth = true,

  $reset_data = false,
  $reset_cache = false
  ) inherits pulp::params {

  include apache

  class { mongodb:
    logpath => '/var/lib/mongodb/mongodb.log',
    dbpath => '/var/lib/mongodb',
  }
  class { qpid: }

  class { 'pulp::install':
    require => [Class['mongodb'], Class['qpid']]
  } ~>
  class { 'pulp::config':
    require => [Class['mongodb'], Class['qpid']]
  } ~>
  Service['httpd']
  ->
  Class[pulp]
}
