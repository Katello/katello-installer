# Candlepin params
class candlepin::params {

  $tomcat = $::osfamily ? {
    /^(RedHat|Linux)/ => $::operatingsystem ? {
      'Fedora'  => 'tomcat',
      default   => $::operatingsystemrelease ? {
        /^7\./  => 'tomcat',
        default => 'tomcat6'
      }
    }
  }

  $manage_db = true
  $db_type = 'postgresql'
  $db_host = 'localhost'
  $db_user = 'candlepin'
  $db_name = 'candlepin'
  $db_port = undef

  # this comes from keystore
  $db_password = cache_data('candlepin_db_password', random_password(32))
  $amqp_keystore_password = $::certs::candlepin::keystore_password
  $amqp_truststore_password = $::certs::candlepin::keystore_password

  # where to store output from cpsetup execution
  $log_dir  = '/var/log/candlepin'

  $crl_file = '/var/lib/candlepin/candlepin-crl.crl'

  $oauth_key = 'candlepin'
  $oauth_secret = 'candlepin'

  $thumbslug_oauth_key = 'thumbslug'
  $thumbslug_oauth_secret = 'thumbslug'

  $ca_key = '/etc/candlepin/certs/candlepin-ca.key'
  $ca_cert = '/etc/candlepin/certs/candlepin-ca.crt'
  $ca_key_password = undef

  $user_groups = []

  $env_filtering_enabled = true
  $thumbslug_enabled = false

  $deployment_url = 'candlepin'

  $qpid_ssl_port = 5671

  $version = 'installed'
  $run_init = true
  $adapter_module = 'org.candlepin.katello.KatelloModule'
  $amq_enable = true
  $enable_hbm2ddl_validate = true

}
