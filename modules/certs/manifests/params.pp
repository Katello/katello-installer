# Certs Parameters
class certs::params {

  $tomcat = $::osfamily ? {
    /^(RedHat|Linux)/ => $::operatingsystem ? {
      'Fedora'  => 'tomcat',
      default   => $::operatingsystemrelease ? {
        /^7\./  => 'tomcat',
        default => 'tomcat6'
      }
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

  $default_ca_name = 'katello-default-ca'
  $server_ca_name  = 'katello-server-ca'

  $country       = 'US'
  $state         = 'North Carolina'
  $city          = 'Raleigh'
  $org           = 'Katello'
  $org_unit      = 'SomeOrgUnit'
  $expiration    = '7300' # 20 years
  $ca_expiration = '36500' # 100 years

  $keystore_password_file = 'keystore_password-file'
  $nss_db_dir = "${pki_dir}/nssdb"

  $user = 'root'
  $group = 'root'

  $server_cert      = undef
  $server_key       = undef
  $server_cert_req  = undef
  $server_ca_cert   = undef

  $foreman_client_cert    = '/etc/foreman/client_cert.pem'
  $foreman_client_key     = '/etc/foreman/client_key.pem'
  # for verifying the foreman proxy https
  $foreman_ssl_ca_cert    = '/etc/foreman/proxy_ca.pem'

  $foreman_proxy_cert    = '/etc/foreman-proxy/ssl_cert.pem'
  $foreman_proxy_key     = '/etc/foreman-proxy/ssl_key.pem'
  # for verifying the foreman client certs at the proxy side
  $foreman_proxy_ca_cert = '/etc/foreman-proxy/ssl_ca.pem'

  $foreman_proxy_foreman_ssl_cert    = '/etc/foreman-proxy/foreman_ssl_cert.pem'
  $foreman_proxy_foreman_ssl_key     = '/etc/foreman-proxy/foreman_ssl_key.pem'
  # for verifying the foreman https
  $foreman_proxy_foreman_ssl_ca_cert = '/etc/foreman-proxy/foreman_ssl_ca.pem'

  $puppet_client_cert = '/etc/puppet/client_cert.pem'
  $puppet_client_key  = '/etc/puppet/client_key.pem'
  # for verifying the foreman https
  $puppet_ssl_ca_cert = '/etc/puppet/ssl_ca.pem'

  $candlepin_keystore               = '/etc/pki/katello/keystore'
  $candlepin_certs_dir              = '/etc/candlepin/certs'
  $candlepin_ca_cert                = "${candlepin_certs_dir}/candlepin-ca.crt"
  $candlepin_ca_key                 = "${candlepin_certs_dir}/candlepin-ca.key"
  $candlepin_amqp_store_dir         = "${candlepin_certs_dir}/amqp"
  $candlepin_amqp_truststore        = "${candlepin_amqp_store_dir}/candlepin.truststore"
  $candlepin_amqp_keystore          = "${candlepin_amqp_store_dir}/candlepin.jks"
  $candlepin_qpid_exchange          = 'event'

  $gutterball_certs_dir              = '/etc/gutterball/certs'
  $gutterball_amqp_store_dir         = "${gutterball_certs_dir}/amqp/"
  $gutterball_amqp_truststore        = "${gutterball_amqp_store_dir}/gutterball.truststore"
  $gutterball_amqp_keystore          = "${gutterball_amqp_store_dir}/gutterball.jks"
  $gutterball_keystore_password_file = "${pki_dir}/keystore_password-file-gutterball"

  $certs_tar              = undef
  # Settings for uploading packages to Katello
  $katello_user           = undef
  $katello_password       = undef
  $katello_org            = 'Katello Infrastructure'
  $katello_repo_provider  = 'node-installer'
  $katello_product        = 'node-certs'
  $katello_activation_key = undef

  $messaging_client_cert = "${pki_dir}/qpid_client_striped.crt"

  $qpid_router_server_cert = "${pki_dir}/qpid_router_server.crt"
  $qpid_router_client_cert = "${pki_dir}/qpid_router_client.crt"
  $qpid_router_server_key  = "${pki_dir}/qpid_router_server.key"
  $qpid_router_client_key  = "${pki_dir}/qpid_router_client.key"
  $qpid_router_owner       = 'qdrouterd'
  $qpid_router_group       = 'root'

  $pulp_server_ca_cert   = '/etc/pki/pulp/server_ca.crt'
  # Pulp expects the node certificate to be located on this very location
  $nodes_cert_dir        = '/etc/pki/pulp/nodes'
  $nodes_cert_name       = 'node.crt'

  $qpidd_group = 'qpidd'
}
