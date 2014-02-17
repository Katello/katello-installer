# Certs Parameters
class certs::params {

  case $::operatingsystem {
    'Fedora': {
      $tomcat = 'tomcat'
    }
    default: {
      $tomcat = 'tomcat6'
    }
  }

  $log_dir = '/var/log/certs'

  $node_fqdn = $::fqdn

  $custom_repo = false

  $ca_common_name = $::fqdn  # we need fqdn as CA common name as candlepin uses it as a ssl cert

  $generate      = true
  $regenerate    = false
  $regenerate_ca = false
  $deploy        = true

  $country       = 'US'
  $state         = 'North Carolina'
  $city          = 'Raleigh'
  $org           = 'SomeOrg'
  $org_unit      = 'SomeOrgUnit'
  $expiration    = '365'
  $ca_expiration = '36500'

  $password_file_dir  = '/etc/katello'
  $nss_db_dir = '/etc/pki/katello/nssdb'

  $user = 'root'
  $group = 'root'

  $foreman_client_cert = '/etc/foreman/client_cert.pem'
  $foreman_client_key  = '/etc/foreman/client_key.pem'
  $foreman_client_ca   = '/etc/foreman/client_ca.pem'

  $foreman_proxy_cert = '/etc/foreman-proxy/ssl_cert.pem'
  $foreman_proxy_key  = '/etc/foreman-proxy/ssl_key.pem'
  $foreman_proxy_ca   = '/etc/foreman-proxy/ssl_ca.pem'

  $puppet_client_cert = '/etc/puppet/client_cert.pem'
  $puppet_client_key  = '/etc/puppet/client_key.pem'
  $puppet_client_ca   = '/etc/puppet/client_ca.pem'

  $apache_ssl_cert = '/etc/pki/tls/certs/katello-node.crt'
  $apache_ssl_key  = '/etc/pki/tls/private/katello-node.key'
  $apache_ca_cert  = '/etc/pki/tls/certs/katello-ca.crt'

  $candlepin_certs_storage          = '/etc/candlepin/certs'
  $candlepin_ca_cert                = '/etc/candlepin/certs/candlepin-ca.crt'
  $candlepin_ca_key                 = '/etc/candlepin/certs/candlepin-ca.key'
  $candlepin_pki_dir                = '/etc/pki/katello'
  $candlepin_keystore               = '/etc/pki/katello/keystore'
  $candlepin_certs_dir              = '/etc/candlepin/certs'

  $certs_tar              = undef
  # Settings for uploading packages to Katello
  $katello_user           = undef
  $katello_password       = undef
  $katello_org            = 'Katello Infrastructure'
  $katello_repo_provider  = 'node-installer'
  $katello_product        = 'node-certs'
  $katello_activation_key = undef


}
