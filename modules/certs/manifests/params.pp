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
  $pki_dir = '/etc/pki/katello'
  $ssl_build_dir = '/root/ssl-build'

  $node_fqdn = $::fqdn

  $custom_repo = false

  $ca_common_name = $::fqdn  # we need fqdn as CA common name as candlepin uses it as a ssl cert

  $generate      = true
  $regenerate    = false
  $regenerate_ca = false
  $deploy        = true

  $default_ca_name = 'katello-ca'
  $country       = 'US'
  $state         = 'North Carolina'
  $city          = 'Raleigh'
  $org           = 'SomeOrg'
  $org_unit      = 'SomeOrgUnit'
  $expiration    = '365'
  $ca_expiration = '36500'

  $keystore_password_file = 'keystore_password-file'
  $nss_db_dir = "${pki_dir}/nssdb"

  $user = 'root'
  $group = 'root'

  $foreman_client_cert    = '/etc/foreman/client_cert.pem'
  $foreman_client_key     = '/etc/foreman/client_key.pem'
  $foreman_client_ca_cert = '/etc/foreman/client_ca.pem'

  $foreman_proxy_cert    = '/etc/foreman-proxy/ssl_cert.pem'
  $foreman_proxy_key     = '/etc/foreman-proxy/ssl_key.pem'
  $foreman_proxy_ca_cert = '/etc/foreman-proxy/ssl_ca.pem'

  $puppet_client_cert = '/etc/puppet/client_cert.pem'
  $puppet_client_key  = '/etc/puppet/client_key.pem'
  $puppet_client_ca_cert = '/etc/puppet/client_ca.pem'

  $candlepin_certs_storage          = '/etc/candlepin/certs'
  $candlepin_ca_cert                = '/etc/candlepin/certs/candlepin-ca.crt'
  $candlepin_ca_key                 = '/etc/candlepin/certs/candlepin-ca.key'
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

  $messaging_client_cert = "${pki_dir}/qpid_client_striped.crt"
  # Pulp expects the node certificate to be located on this very location
  $nodes_cert_dir        = '/etc/pki/pulp/nodes'
  $nodes_cert_name       = 'node.crt'
}
